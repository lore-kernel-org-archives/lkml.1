Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYHYMEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYHYMEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYHYMEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:04:40 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:46969 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYHYMEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:04:39 -0400
Message-ID: <48B29F7B.6080405@hp.com>
Date: Mon, 25 Aug 2008 08:03:07 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 23 Aug 2008, Linus Torvalds wrote:
>> This one makes no sense. It's triggering a BUG_ON(in_interrupt()), but 
>> then the call chain shows that there is no interrupt going on.
> 
> Ahh, later in that thread there's another totally unrelated oops in 
> debug_mutex_add_waiter().
> 
> I'd guess that it is really wild pointer corrupting memory, quite possibly 
> due to a double free or something like that. Alan - it would be good to 
> run with DEBUG_PAGE_ALLOC and SLUB debugging etc if you don't already do 
> that?
> 
> 		Linus
> 

I'll add those in - as to the repeatability: The "bad" kernels seem to
repeat quite reliably - not only in terms of counts (5 or 6 times in a
row before trying something else), but also in terms of the "what" -
either the original issue () or the other kernel with the later issue
(debug_mutex_add_waiter). That's /goodness/ in that it should help
narrow it down.

I'll make sure the kernel is still failing this morning, and then add in
DEBUG_PAGE_ALLOC and if that doesn't help, SLUB debugging...

Alan
