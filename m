Return-Path: <linux-kernel-owner+w=401wt.eu-S934210AbXEEXJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934210AbXEEXJL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 19:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934216AbXEEXJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 19:09:11 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:34827 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934210AbXEEXJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 19:09:10 -0400
Date: Sun, 6 May 2007 01:09:07 +0200
From: Bernd Schubert <bs@q-leap.de>
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Cc: bernd-schubert@gmx.de, Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: mkfs.ext2 triggerd RAM corruption
Message-ID: <20070505230907.GA27188@lanczos.q-leap.de>
References: <200705041659.51675.bs@q-leap.de> <20070504184943.GC25339@thunk.org> <20070505013637.GA23803@lanczos.q-leap.de> <20070505185735.GB21049@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505185735.GB21049@thunk.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 02:57:35PM -0400, Theodore Tso wrote:
> On Sat, May 05, 2007 at 03:36:37AM +0200, Bernd Schubert wrote:
> > distribution: modified debian sarge, in which aspect is the distribution
> > important for this problem? mkfs2.ext2 is supposed to write to /dev/sdaX
> > and not /dev/rd/0. Stracing it and grepping for open calls shows that
> > only /dev/sdaX is opened in read-write mode.
> 
> /dev/rd/0?  What's this?  Is this the partition where your root
> partition is found?  What is it?  Is it a ramdisk?  Or is it some kind
> of persistent storage device?
> 
> If it is a persistant storage device, do the corrupted files stay
> corrupted when you reboot?  (If it's a ramdisk which you load, then
> obviously it's getting reloaded on reboot.)  You didn't give enough
> information to be sure exactly what's going on.

Sorry, should have expressed myself more clearly, /dev/rd/0 is the
devfs-style name of the first ram disk device (don't like those devfs
names myself, but since I'm rather new in this group I couldn't convice
my boss to switch to short names yet ;) ). However, its only the
devfs-style of udev and not devfs itself.

> 
> The next thing to ask is how the files are corrupted.  Can you see
> save a copy of the corrupted files to stable storage, so you can see
> *how* they were corrupted.  Were large swaths of zeros getting written
> into it?

Yes, many zeros. Binary files, hexdump and diff are here:
http://www.q-leap.com/~bschubert/data-corruption

> 
> Next question; if you don't use these mke2fs parameters, can you
> reproduce the corruption?
> 
> 	mkfs.ext2 -j -b 4096 -F -i 4096 -J size=400 -I 512 /dev/sda4
> 
> What if you change the it to:
> 
> 	mkfs.ext2 -j -b 4096  /dev/sda4
> 
> Do you still see corruption problems?

No, no observable corruption.

> 
> > I already tested several partition types, e.g. something like this for a
> > test on sda3
> > 
> > beo-05:~# sfdisk -d /dev/sda
> > # partition table of /dev/sda
> > unit: sectors
> > 
> > /dev/sda1 : start=       63, size=  4208967, Id=83
> > /dev/sda2 : start=  4209030, size=  4209030, Id=83
> > /dev/sda3 : start=  8418060, size=313251435, Id=83
> > /dev/sda4 : start=        0, size=        0, Id= 0
> 
> What if the partition size is smaller; does that make the problem go
> away?  If so, can you do a binary search on the partition size where
> the problem appears?

Need to test this thouroughly, but will do it tomorrow, its too late
here for this kind of tests.

> 
> And what can you say about the SATA driver you were using; were all of
> the machines that you tested this on using the same SATA controller
> and same driver?  

As you can see from my previous reply ;) tested with at least two
different controllers - intel and nvidia (will reboot on the 4th system on Monday to
figure out its hardware, once the corruption happened, the system tend to
stop working).

> 
> Obviously if this were a generic kernel problem, we'd been hearing
> about this from a lot more people.  So there has to be something
> unique to your setup, and we need to figure out what that might happen
> to be.

I also still have problems to believe its a generic problem...


Thanks for your help,
Bernd

