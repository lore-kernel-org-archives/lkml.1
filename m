Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbZDZXMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbZDZXMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 19:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZDZXMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 19:12:38 -0400
Received: from mail2.shareable.org ([80.68.89.115]:43981 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZDZXMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 19:12:37 -0400
Date: Mon, 27 Apr 2009 00:12:09 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, David VomLehn <dvomlehn@cisco.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090426231208.GA17240@shareable.org>
References: <20090426195249.GC10627@shareable.org> <Pine.LNX.4.44L0.0904261715250.26439-100000@netrider.rowland.org> <20090426213746.GH10627@shareable.org> <ac3eb2510904261536t7a37f970tfafba71d1e67cfb6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510904261536t7a37f970tfafba71d1e67cfb6@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> > _If_ the system doesn't wait for all block devices present at boot to
> > be enumerated before the boot script, then when the script looks in
> > that directory for a specific UUID, it would be good to wait until
> > "has everything present at boot been enumerated?" says yes.
> 
> That's what distros do with initramfs today.

I don't see how that's possible.  Haven't we been discussing how the
USB driver does not have any support (yet) for saying when it's found
every device present at boot time, and that it can probably be added?

I have a boot script which does this:

    1. *If* USB disk plugged in, mount it on /mnt/usb, do some stuff.
    2. If not, do something else.

If I'm not mistaken, the only way to do that right now is pick an
arbitrary time, wait, and proceed with 2 if you didn't see the disk.

The desired USB console behaviour is very similar.  Use it if it's
plugged in at boot, use something else otherwise, and no arbitrary
delays.

Did I miss something?
> > Since this is all about making boot faster, it would be quite nice not
> > to wait for all block devices before starting the boot script, or at
> > least the initramfs module-loading script :-)
> 
> You wait in initramfs until the device show up. Usually dynamic udev
> rules created from the root= string of the kernel commandline create a
> rule which matches on the UUID, and creates a /dev/root symlink when
> the device shows up. As soon as this link shows up,  init mounts it
> and goes ahead.

That's fine when you're waiting for a device to appear that you know
will appear.

The USB console excitement, and my mention of USB disks and such, is
how to decide when the device _isn't_ going to appear, without an
arbitrary timeout.

-- Jamie
