Return-Path: <linux-kernel-owner+w=401wt.eu-S1751856AbZGODSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbZGODSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 23:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbZGODSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 23:18:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:54716 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbZGODSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 23:18:34 -0400
Message-ID: <4A5D4A39.9020000@kernel.org>
Date: Wed, 15 Jul 2009 12:17:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
       cl@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 04/10] percpu: make 4k first chunk allocator map memory
References: <1245850216-31653-5-git-send-email-tj@kernel.org> <1245850216-31653-1-git-send-email-tj@kernel.org> <24253.1247479973@redhat.com>
In-Reply-To: <24253.1247479973@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Jul 2009 03:17:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

David Howells wrote:
> Tejun Heo <tj@kernel.org> wrote:
> 
>> +	pr_info("PERCPU: %d 4k pages per cpu, static data %zu bytes\n",
>> +		pcpu4k_unit_pages, static_size);
> 
> It occurs to me that this is may include a bad assumption.  Page size need not
> be 4K.  I don't know that it matters, but looking at this:
> 
>> +	vm.size = num_possible_cpus() * pcpu4k_unit_pages << PAGE_SHIFT;
>> +	vm_area_register_early(&vm, PAGE_SIZE);
> 
> It might.

Yeah, I realized that after trying to convert powerpc64 and ia64 and
renamed it to page.  I'll soon post the patches.

Thanks.

-- 
tejun
