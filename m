Return-Path: <linux-kernel-owner+w=401wt.eu-S2993123AbXDYWzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993123AbXDYWzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993132AbXDYWzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:55:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57337 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993123AbXDYWzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:55:42 -0400
Date: Wed, 25 Apr 2007 23:57:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
Message-ID: <20070425235718.66b71f01@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu>
	<20070424202336.GC16503@elf.ucw.cz>
	<alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	<20070424212408.GD16457@elf.ucw.cz>
	<alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	<20070425072350.GA6866@ucw.cz>
	<Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
	<alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
	<20070425202741.GC17387@elf.ucw.cz>
	<alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
	<20070425214420.GG17387@elf.ucw.cz>
	<alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Tell me, what does "suspend" do, and what does "freeze" (snapshot) do?
> 
> And name *one* thing that have in common.

Both of them have to ensure you can make a consistent snapshot. Doing
that means you've got to be able to define a single "point" at which the
snapshot is made and is internally self-consistent. That in both cases
tends to mean you've got to ensure nothing occurs which pees on the image
while you are making that snapshot (such as outstanding O_DIRECT I/O to
user pages).

Alan
