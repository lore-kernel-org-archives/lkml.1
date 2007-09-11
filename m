Return-Path: <linux-kernel-owner+w=401wt.eu-S967037AbXIKUSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967037AbXIKUSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966011AbXIKUK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:10:58 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43854 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965991AbXIKUK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:10:56 -0400
Date: Tue, 11 Sep 2007 22:12:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: x86 merge - a little feedback
Message-ID: <20070911201219.GA9674@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas et al.

After spending several hours fiddeling with and improving
the current Makefile for x86_64 I decided to take a closer look
at the x86 merge og i386 and x86_64.

I took a closer look at x86/pci. There are 16 C files.

>From the mails and discussions I expected it be be
obvious what was i386 only, what was shared and what was x86_64 only.

But see following table

Filename		i386	x86_64
acpi.c			X	X
common.c		X	X
direct.c		X	X
early.c			X	X
fixup.c			X	X
i386.c			X	X
init.c			X	X
irq.c			X
k8-bus.c			X
legacy.c		X	X
mmconfig_32.c		X
mmconfig_64.c			X
mmconfig-shared.c	X	X
numa.c			X
pcbios.c		X
visws.c			X

In the filename there is NOTHING for most of
the non-shared code that tell that this file is
used by only i386 or x86_64.

The exception is mmconfig that is prefixed with _32 versus _64.
But as I have understood the mails floating around using _32,_64
is a way to say here are a potential candidate for futher merging.

In a meged x86 tree it would be very beneficial to either include
in the filename that a specific file is i386 or x86_64 specific or
stuff them in a separate subdirectory.

If legacy.c numa.c, pcibios.c and visws.c placed in a directory named i386
then it would be obvious that this is i386 only.
Or they could be named filename_32 (or the uglier filename_i386).
As it stands out today the filename are kept but thier relationship are lost.

I dunno if this will address the concern of Andi about mixing i386 and x86_64
but to me at least things would be so much more obvious if the original
relationship are spelled out.

	Sam
