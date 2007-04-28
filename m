Return-Path: <linux-kernel-owner+w=401wt.eu-S1163340AbXD1R7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163340AbXD1R7q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163363AbXD1R7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:59:22 -0400
Received: from smtp-out.google.com ([216.239.45.13]:33318 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163307AbXD1R6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:58:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:from:message-id:to:cc:subject:date:mime-version:
	content-type:content-transfer-encoding:x-mailer:in-reply-to:x-mimeole:thread-index;
	b=tFZBGcROz5UghRttWT1kj0xZyEUUwD9Z+hMgqunU83ibPi2cFMJ7ciJJdU60/YVfP
	dW1rsu3CJ3z+nRemuCccA==
From: Rohit Seth <rohitseth@google.com>
Message-Id: <200704281757.l3SHvUrs026921@smtp.corp.google.com>
To: "'Nick Piggin'" <nickpiggin@yahoo.com.au>
Cc: "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Hugh Dickins'" <hugh@veritas.com>,
       "'Luck, Tony'" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: RE: Fw: [PATCH] ia64: race flushing icache in do_no_page path
Date: Sat, 28 Apr 2007 10:57:19 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.6353
In-Reply-To: <4632AAB4.6030303@yahoo.com.au>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AceJOQcuiCZ3ahQJQF2Q3pkiPS739AAggDNQ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

-----Original Message-----
From: Nick Piggin [mailto:nickpiggin@yahoo.com.au] 
Sent: Friday, April 27, 2007 7:00 PM
To: rohitseth@google.com
Cc: Mike Stroyan; Andrew Morton; Hugh Dickins; Luck, Tony;
linux-ia64@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path

Rohit Seth wrote:
> 
> 
>> You mean by user space? If so, then it is user space responsibility to 
>> do the appropriate operations (like flush icache in this case).

>No, I mean places that set PG_arch_1. flush_dcache_page. This can happen 
>for mapped pages in write, splice, install_arg_page looks questionable,
direct IO...


If a user is requesting kernel to do (for example) write on a page that is
already mapped with execute and write permissions then it should be treated
as if the user space is doing modifications to that page.  There is no
change in protections so lazy_prot_mmu_update shouldn't be called even
though PG_arch_1 is (I think) set.  Does it answer your concern?

>What if you were to say remove all the PG_arch_1 code, and do 
>something really simple like flush icache in 
>flush_dcache_page? Would performance suffer horribly?

On Itanium, I think it will have some performance penalty (horrible or not I
don't know) as you will be invalidating the caches more often.  And they
alsways look for last 0.1% performance that they can get.

-rohit

