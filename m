Return-Path: <linux-kernel-owner+w=401wt.eu-S967309AbXIKUZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967309AbXIKUZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760481AbXIKUZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:25:19 -0400
Received: from www.osadl.org ([213.239.205.134]:39274 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758780AbXIKUZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:25:17 -0400
Subject: Re: x86 merge - a little feedback
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070911201219.GA9674@uranus.ravnborg.org>
References: <20070911201219.GA9674@uranus.ravnborg.org>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 22:25:14 +0200
Message-Id: <1189542314.5235.48.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

On Tue, 2007-09-11 at 22:12 +0200, Sam Ravnborg wrote:
> Hi Thomas et al.
> 
> After spending several hours fiddeling with and improving
> the current Makefile for x86_64 I decided to take a closer look
> at the x86 merge og i386 and x86_64.
> 
> I took a closer look at x86/pci. There are 16 C files.
> 
> From the mails and discussions I expected it be be
> obvious what was i386 only, what was shared and what was x86_64 only.
> 
> But see following table
> 
> Filename		i386	x86_64
> acpi.c			X	X
> common.c		X	X
> direct.c		X	X
> early.c			X	X
> fixup.c			X	X
> i386.c			X	X
> init.c			X	X
> irq.c			X
> k8-bus.c			X
> legacy.c		X	X
> mmconfig_32.c		X
> mmconfig_64.c			X
> mmconfig-shared.c	X	X
> numa.c			X
> pcbios.c		X
> visws.c			X
> 
> In the filename there is NOTHING for most of
> the non-shared code that tell that this file is
> used by only i386 or x86_64.

True. I tried to unify the Makefile by using 

obj-$(CONFIG_X86_32) += ....
and
obj-$(CONFIG_X86_64) += ....

but I did fail due to link order problems in that code. I had not yet
time to go down and figure that out yet, but it is on my todo list.

> The exception is mmconfig that is prefixed with _32 versus _64.
> But as I have understood the mails floating around using _32,_64
> is a way to say here are a potential candidate for futher merging.

Yes, if it is possible and makes sense.

> In a meged x86 tree it would be very beneficial to either include
> in the filename that a specific file is i386 or x86_64 specific or
> stuff them in a separate subdirectory.
> 
> If legacy.c numa.c, pcibios.c and visws.c placed in a directory named i386
> then it would be obvious that this is i386 only.
> Or they could be named filename_32 (or the uglier filename_i386).
> As it stands out today the filename are kept but thier relationship are lost.

We concentrated first on the move to make it simple and binary
equivalent. The cleanup of code (merging, location, makefile updates)
are definitely on our todo list.

> I dunno if this will address the concern of Andi about mixing i386 and x86_64
> but to me at least things would be so much more obvious if the original
> relationship are spelled out.

Good point.

	tglx


