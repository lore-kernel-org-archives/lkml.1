Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbXEALni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbXEALni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030599AbXEALni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:43:38 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:39075 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754536AbXEALnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:43:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=aekRssZi7OJEV58bOuzj2g3Rhg/KDtqApkfU2iMZMPAWdigRWri0TWCAc75Lgj1kSPlgCzcjJBeGaT9+YbYb+6w0TRIspVvoLziU3s8Y+eG9iEBdaQbv/UKh6ZsXQxGRSpK2c3GMlGAfUy2r922ef24tHPNZbbz/T3/3BKZtrYo=  ;
X-YMail-OSG: 0UGcEl8VM1lRAHcLoEfO.9jTcDyyr8sUAI6wBn64yL7ck8iagxUIuDHxCJhTzF_Q2sMSCVYmpA--
Message-ID: <463727E1.3090203@yahoo.com.au>
Date: Tue, 01 May 2007 21:43:29 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rohit Seth <rohitseth@google.com>
CC: "'Hugh Dickins'" <hugh@veritas.com>,
       "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Luck, Tony'" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
References: <200704281805.l3SI5JQx030827@smtp.corp.google.com>
In-Reply-To: <200704281805.l3SI5JQx030827@smtp.corp.google.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rohit Seth wrote:
>  
> 
> -----Original Message-----
> From: Hugh Dickins [mailto:hugh@veritas.com] 
> Sent: Friday, April 27, 2007 10:20 PM
> To: Nick Piggin
> Cc: rohitseth@google.com; Mike Stroyan; Andrew Morton; Luck, Tony;
> linux-ia64@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
> 
> On Sat, 28 Apr 2007, Nick Piggin wrote:
> 
>>OIC, you need a virtual address to evict the icache, so you can't 
>>flush at flush_dcache time? Or does ia64 have an instruction to flush 
>>the whole icache? (it would be worth testing, to see how much 
>>performance suffers).
> 
> 
> IIRC, there is a PAL call to flush the whole cache (but that is quite a
> heavy call).  Though you really don't need to be doing this.
> 
> 
>>I'm puzzled by that remark: the ia64 flush_icache_range always has a 
>>virtual address, it uses the kernel virtual address; it takes 
>>no interest in whether there's a user virtual address.
> 
> 
> Caches on Itanium are physical.  So, it doesn't matter what virtual address
> you use to flush a cache line, cache line containing specific physical
> memory will be flushed. 

Really? I was under the vague impression that L1 i/d caches were virtual
and required this flushing... but I guess so long as the ISA says that
fc/fc.i flushes all caches corresponding to the physical address of the
provided virtual address, then that's what matters.

> For the cases where you have virtual caches,
> update_mmu_cache is the API to use.

But it happens after the pte is installed.

-- 
SUSE Labs, Novell Inc.
