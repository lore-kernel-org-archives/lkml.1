Return-Path: <linux-kernel-owner+w=401wt.eu-S1756515AbYHWUS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbYHWUS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 16:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbYHWUSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 16:18:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754732AbYHWUSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 16:18:15 -0400
Date: Sat, 23 Aug 2008 13:17:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik> <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Aug 2008, Linus Torvalds wrote:
> 
> This one makes no sense. It's triggering a BUG_ON(in_interrupt()), but 
> then the call chain shows that there is no interrupt going on.

Ahh, later in that thread there's another totally unrelated oops in 
debug_mutex_add_waiter().

I'd guess that it is really wild pointer corrupting memory, quite possibly 
due to a double free or something like that. Alan - it would be good to 
run with DEBUG_PAGE_ALLOC and SLUB debugging etc if you don't already do 
that?

		Linus
