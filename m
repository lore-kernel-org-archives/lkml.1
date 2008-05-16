Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbYEPNlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbYEPNlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbYEPNlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:41:20 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53587 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758040AbYEPNlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:41:19 -0400
Message-ID: <482D8EFC.8040109@sgi.com>
Date: Fri, 16 May 2008 06:41:16 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] modules: Use a better scheme for refcounting
References: <482C9FC5.2070508@cosmosbay.com> <200805161009.12142.rusty@rustcorp.com.au> <482D1BCE.3060501@cosmosbay.com>
In-Reply-To: <482D1BCE.3060501@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Rusty Russell a écrit :
...
>>
>> Hi Eric,
>>
>>    I like this patch!  The plan was always to create a proper dynamic
>> per-cpu
>> allocator which used the normal per-cpu offsets, but I think module
>> refcounts
>> are worthwhile as a special case.
>>
>>    Any chance I can ask you look at the issue of full dynamic per-cpu
>> allocation?  The problem of allocating memory which is laid out precisely
>> as the original per-cpu alloc is vexing on NUMA, and probably requires
>> reserving virtual address space and remapping into it, but the rewards
>> would be maximally-efficient per-cpu accessors, and getting rid of that
>> boutique allocator in module.c.
>>
>>   
> You mean using alloc_percpu() ? Problem is that current implementation
> is expensive, since it is using
> an extra array of pointers (struct percpu_data). On x86_64, that means
> at least a 200% space increase
> over the solution of using 4 bytes in the static percpu zone. We
> probably can change this to dynamic
> per-cpu as soon as Mike or Christopher finish their work on new dynamic
> per-cpu implementation ?


Yes, the zero-based percpu variables followed by the cpu_alloc patch should
provide this and shrink the code quite well, including in some cases removing
locking requirements (because the resultant instructions will be atomic.)

Thanks,
Mike
