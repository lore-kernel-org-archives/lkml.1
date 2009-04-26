Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZDZVVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZDZVVQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 17:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZDZVU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 17:20:56 -0400
Received: from netrider.rowland.org ([192.131.102.5]:46859 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751629AbZDZVU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 17:20:56 -0400
Date: Sun, 26 Apr 2009 17:20:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jamie Lokier <jamie@shareable.org>
cc: David VomLehn <dvomlehn@cisco.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
In-Reply-To: <20090426195249.GC10627@shareable.org>
Message-ID: <Pine.LNX.4.44L0.0904261715250.26439-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009, Jamie Lokier wrote:

> > Are you suggesting this new interface be exported to userspace somehow?
> 
> Not directly.  Only in the same way that open("/dev/console") delays
> until there's a console, so reading the keyboard can delay until we
> know if we had a keyboard plugged in at boot, and looking for a disk
> called UUID=392852908752345749857 can wait until we know if there was
> one plugged in at boot time.
> 
> The latter issue with UUID is done in userspace now by reading all
> disks, but I'm under the impression changes are planned in that
> department because reading every disk from userspace to locate
> specific ones is too slow on big systems.

IIUC, David is proposing that no userspace process should get started
until some (all?) of the console devices and the block device
containing the root filesystem (all block devices present at boot?)
have been registered.  That would remove the need for your delays, at 
least in part.

As for searching for a particular UUID, I believe recent changes to 
sysfs/udev should improve the situation.  There will be a "by_UUID" 
directory somewhere, containing a bunch of symbolic links whose names 
are the UUID values of all the registered drives.  Programs won't have 
to read every disk; they'll only have to search through this directory.

Alan Stern

