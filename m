Return-Path: <linux-kernel-owner+w=401wt.eu-S1751957AbZDZVij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbZDZVij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 17:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZDZVi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 17:38:27 -0400
Received: from mail2.shareable.org ([80.68.89.115]:52894 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZDZVi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 17:38:26 -0400
Date: Sun, 26 Apr 2009 22:37:46 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David VomLehn <dvomlehn@cisco.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090426213746.GH10627@shareable.org>
References: <20090426195249.GC10627@shareable.org> <Pine.LNX.4.44L0.0904261715250.26439-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904261715250.26439-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Sun, 26 Apr 2009, Jamie Lokier wrote:
> 
> > > Are you suggesting this new interface be exported to userspace somehow?
> > 
> > Not directly.  Only in the same way that open("/dev/console") delays
> > until there's a console, so reading the keyboard can delay until we
> > know if we had a keyboard plugged in at boot, and looking for a disk
> > called UUID=392852908752345749857 can wait until we know if there was
> > one plugged in at boot time.
> > 
> > The latter issue with UUID is done in userspace now by reading all
> > disks, but I'm under the impression changes are planned in that
> > department because reading every disk from userspace to locate
> > specific ones is too slow on big systems.
> 
> IIUC, David is proposing that no userspace process should get started
> until some (all?) of the console devices and the block device
> containing the root filesystem (all block devices present at boot?)
> have been registered.  That would remove the need for your delays, at 
> least in part.
> 
> As for searching for a particular UUID, I believe recent changes to 
> sysfs/udev should improve the situation.  There will be a "by_UUID" 
> directory somewhere, containing a bunch of symbolic links whose names 
> are the UUID values of all the registered drives.  Programs won't have 
> to read every disk; they'll only have to search through this directory.

That will be great.

_If_ the system doesn't wait for all block devices present at boot to
be enumerated before the boot script, then when the script looks in
that directory for a specific UUID, it would be good to wait until 
"has everything present at boot been enumerated?" says yes.

Otherwise you have hacks like my boot script which waits 5 seconds for
a disk to show up on USB, and then continues if not.  It sounds
awfully like waiting X seconds for a USB console to show up :-)

Since this is all about making boot faster, it would be quite nice not
to wait for all block devices before starting the boot script, or at
least the initramfs module-loading script :-)

That's outside the scope of bootconsole and root device.  I certainly
won't demand it's done, but I'm sure you can see a strong similarity:
the ability to wait in the kernel until a class of devices that were
present at boot have finished enumerating.

-- Jamie
