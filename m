Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbXDZBL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbXDZBL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 21:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbXDZBL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 21:11:58 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520AbXDZBL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 21:11:57 -0400
Date: Wed, 25 Apr 2007 18:10:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Pavel Machek <pavel@ucw.cz>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070426012454.3495b5d8@the-village.bc.nu>
Message-ID: <alpine.LFD.0.98.0704251808150.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425072350.GA6866@ucw.cz> <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
 <20070425202741.GC17387@elf.ucw.cz> <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
 <20070425214420.GG17387@elf.ucw.cz> <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
 <20070425235718.66b71f01@the-village.bc.nu>
 <alpine.LFD.0.98.0704251610310.9964@woody.linux-foundation.org>
 <20070426012454.3495b5d8@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Alan Cox wrote:
> 
> You bet there is. We need to know if data arrived or not, because there
> is no guarantee that the data retrieved if we inadvertently re-execute a
> command will be the same. The hardware state itself isn't the problem,
> its the combination of hardware state and internal state which need to
> match in some cases.

... which is why "suspend()" suspends the hardware.

Is that so hard to understand?

Once the hardware is suspended, it's not doing anything.

But STR doesn't have any need for atomicity guarantees _between_devices_.

That's a really *fundamental* difference. 

The reason s2ram is *so* different from snapshot-to-disk is exactly the 
fact that s2ram can (and does) work on one device at a time. 

In contrast, snapshot-to-disk needs to snapshot all the devices 
*together*, since it has a separate disk image.

See? Two *totally* different cases. They have *nothing* in common. Not the 
call sequence, not the logic, not *anything*.

		Linus
