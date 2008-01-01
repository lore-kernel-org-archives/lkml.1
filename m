Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbYAAQd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbYAAQd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYAAQdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:33:21 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59034 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbYAAQdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:33:20 -0500
Date: Tue, 1 Jan 2008 17:31:26 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "David P. Reed" <dpreed@reed.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20080101173126.GB1889@ucw.cz>
References: <20071216152250.GA21245@elte.hu> <4765D43E.1010800@gmail.com> <4765D95C.4010404@zytor.com> <4765DCB0.8030901@gmail.com> <4765EE7F.80002@zytor.com> <47667366.7010405@gmail.com> <4766AE88.4080904@zytor.com> <4766D175.7040807@reed.com> <20071217212509.5edaa372@the-village.bc.nu> <477A634C.8040000@reed.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477A634C.8040000@reed.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> 1. It appears to be a real port.  SMI traps are not happening in the
> normal outb to 80.  Hundreds of them execute perfectly with the expected
> instruction counts.  If I can trace the particular event that creates
> the hard freeze (getting really creative, here) and stop before the
> freeze disables the entire computer, I will.  That may be an SMI, or
> perhaps any other kind of interrupt or exception.  Maybe someone knows
> how to safely trace through an impending SMI while doing printk's or
> something?
> 
> 2. It appears to be the standard POST diagnostic port.  On a whim, I
> disassembled my DSDT code, and studied it more closely.   It turns out
> that there are a bunch of "Store(..., DBUG)" instructions scattered
> throughout, and when you look at what DBUG is defined as, it is defined
> as an IO Port at IO address DBGP, which is a 1-byte value = 0x80.  So
> the ACPI BIOS thinks it has something to do with debugging.   There's a
> little strangeness here, however, because the value sent to the port
> occasionally has something to do with arguments to the ACPI operations
> relating to sleep and wakeup ...  could just be that those arguments are
> distinctive.

Maybe someone just left debugging code in production?

> In thinking about this, I recognize a couple of things.  ACPI is telling
> us something when it declares a reference to port 80 in its code.  It's
> not telling us the function of this port on this machine, but it is
> telling us that it is being used by the BIOS.   This could be a reason
> to put out a printk warning message...   'warning: port 80 is used by
> ACPI BIOS - if you are experiencing problems, you might try an alternate
> means of iodelay.'
> 
> Second, it seems likely that there are one of two possible reasons that
> the port 80 writes cause hang/freezes:
> 
> 1. buffer overflow in such a device.
> 
> 2. there is some "meaning" to certain byte values being written (the
> _PTS and _WAK use of arguments that come from callers to store into port
> 80 makes me suspicious.)   That might mean that the freeze happens only
> when certain values are written, or when they are written closely in
> time to some other action - being used to communicate something to the

There's nothing easier than always writing 0 to the 0x80 to check if
it hangs in such case...?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
