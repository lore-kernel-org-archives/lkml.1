Return-Path: <linux-kernel-owner+w=401wt.eu-S1423404AbXDYW7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423404AbXDYW7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423406AbXDYW7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:59:01 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423404AbXDYW7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:59:00 -0400
Date: Wed, 25 Apr 2007 15:58:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
cc: Kenneth Crudup <kenny@panix.com>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Con Kolivas <kernel@kolivas.org>,
       suspend2-devel@lists.suspend2.net, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070425224216.GI17387@elf.ucw.cz>
Message-ID: <alpine.LFD.0.98.0704251556160.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
 <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
 <20070425224216.GI17387@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Pavel Machek wrote:
> 
> Suspend syncs caches/spins down. Freeze does not do anything.
> 
> That's okay, I keep claiming "freeze" is subset of "suspend". Can you
> name device where that is not true?

Sure. Like just about any PCI device that doesn't do things on its own.

A "freeze" does nothing at all, or perhaps shuts down the reader side 
(for something like a network controller).

A "suspend" does "write D3 to the suspend register". Absolutely zero in 
common.

> Remember we do
> 
> suspend(PMSG_FREEZE)
> atomic snapshot
> resume()
> write snapshot.

AND THAT IS STUPID. It mixes up "suspend()" and creating a snapshot in 
ways that are totally idiotic. There is nothing in common!

		Linus
