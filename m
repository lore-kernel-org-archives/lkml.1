Return-Path: <linux-kernel-owner+w=401wt.eu-S1163395AbXD1SGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163395AbXD1SGS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163394AbXD1SGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:06:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:34937 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163395AbXD1SFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 14:05:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:from:message-id:to:cc:subject:date:mime-version:
	content-type:content-transfer-encoding:x-mailer:in-reply-to:x-mimeole:thread-index;
	b=T0yLZqB+r8FENIXwnOFy8tLNiQpB2ku0HCg5sWqCi+cjFEhHeHvbgueOwU58IxxKm
	Tk7G61WERyfYlu0ehCwqQ==
From: Rohit Seth <rohitseth@google.com>
Message-Id: <200704281805.l3SI5JQx030827@smtp.corp.google.com>
To: "'Hugh Dickins'" <hugh@veritas.com>,
       "'Nick Piggin'" <nickpiggin@yahoo.com.au>
Cc: "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Luck, Tony'" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: RE: Fw: [PATCH] ia64: race flushing icache in do_no_page path
Date: Sat, 28 Apr 2007 11:05:09 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.6353
In-Reply-To: <Pine.LNX.4.64.0704280616470.9554@blonde.wat.veritas.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AceJVO7MN/eed43FSZW1lOthvAsgrQAaecbQ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

-----Original Message-----
From: Hugh Dickins [mailto:hugh@veritas.com] 
Sent: Friday, April 27, 2007 10:20 PM
To: Nick Piggin
Cc: rohitseth@google.com; Mike Stroyan; Andrew Morton; Luck, Tony;
linux-ia64@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path

On Sat, 28 Apr 2007, Nick Piggin wrote:
> 
> OIC, you need a virtual address to evict the icache, so you can't 
> flush at flush_dcache time? Or does ia64 have an instruction to flush 
> the whole icache? (it would be worth testing, to see how much 
> performance suffers).

IIRC, there is a PAL call to flush the whole cache (but that is quite a
heavy call).  Though you really don't need to be doing this.

>I'm puzzled by that remark: the ia64 flush_icache_range always has a 
>virtual address, it uses the kernel virtual address; it takes 
>no interest in whether there's a user virtual address.

Caches on Itanium are physical.  So, it doesn't matter what virtual address
you use to flush a cache line, cache line containing specific physical
memory will be flushed.  For the cases where you have virtual caches,
update_mmu_cache is the API to use.

-rohit

