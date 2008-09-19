Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYISNAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYISNAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 09:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYISNA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 09:00:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751026AbYISNA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 09:00:27 -0400
Message-ID: <48D3A22A.40508@linux-foundation.org>
Date: Fri, 19 Sep 2008 07:59:22 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, linux-mm@vger.kernel.org,
       jeremy@goop.org, ebiederm@xmission.com, travis@sgi.com,
       herbert@gondor.apana.org.au, xemul@openvz.org
Subject: Re: [patch 4/4] cpu alloc: Use cpu allocator instead of the builtin
 modules per cpu allocator
References: <20080918233648.581696416@quilx.com> <20080918233701.832528677@quilx.com> <48D3574B.40209@cosmosbay.com>
In-Reply-To: <48D3574B.40209@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Christoph Lameter a écrit :
>> Remove the builtin per cpu allocator from modules.c and use cpu_alloc
>> instead.
>>
>> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
>> +        percpu_size = sechdrs[pcpuindex].sh_size;
>> +
>> +        if (align > PAGE_SIZE) {
>> +            printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
>> +                      mod->name, align, PAGE_SIZE);
>> +            align = PAGE_SIZE;
>> +        }
> 
> Minor question : Wy do you have to keep this cap of alignment ?
> 
> I could not find such a limit in the allocator

The per cpu areas are allocated on page boundaries and there are multiple of
those per cpu areas all aligned to page boundary. The alignment can therefore
only make sense up to a page. Maybe I need to put that into the cpu allocator?



