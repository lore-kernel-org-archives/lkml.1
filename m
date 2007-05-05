Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbXEES5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbXEES5m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbXEES5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:57:42 -0400
Received: from thunk.org ([69.25.196.29]:39561 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbXEES5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:57:38 -0400
Date: Sat, 5 May 2007 14:57:35 -0400
From: Theodore Tso <tytso@mit.edu>
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mkfs.ext2 triggerd RAM corruption
Message-ID: <20070505185735.GB21049@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Bernd Schubert <bs@q-leap.de>, linux-kernel@vger.kernel.org
References: <200705041659.51675.bs@q-leap.de> <20070504184943.GC25339@thunk.org> <20070505013637.GA23803@lanczos.q-leap.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070505013637.GA23803@lanczos.q-leap.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 03:36:37AM +0200, Bernd Schubert wrote:
> distribution: modified debian sarge, in which aspect is the distribution
> important for this problem? mkfs2.ext2 is supposed to write to /dev/sdaX
> and not /dev/rd/0. Stracing it and grepping for open calls shows that
> only /dev/sdaX is opened in read-write mode.

/dev/rd/0?  What's this?  Is this the partition where your root
partition is found?  What is it?  Is it a ramdisk?  Or is it some kind
of persistent storage device?

If it is a persistant storage device, do the corrupted files stay
corrupted when you reboot?  (If it's a ramdisk which you load, then
obviously it's getting reloaded on reboot.)  You didn't give enough
information to be sure exactly what's going on.

The next thing to ask is how the files are corrupted.  Can you see
save a copy of the corrupted files to stable storage, so you can see
*how* they were corrupted.  Were large swaths of zeros getting written
into it?

Next question; if you don't use these mke2fs parameters, can you
reproduce the corruption?

	mkfs.ext2 -j -b 4096 -F -i 4096 -J size=400 -I 512 /dev/sda4

What if you change the it to:

	mkfs.ext2 -j -b 4096  /dev/sda4

Do you still see corruption problems?

> I already tested several partition types, e.g. something like this for a
> test on sda3
> 
> beo-05:~# sfdisk -d /dev/sda
> # partition table of /dev/sda
> unit: sectors
> 
> /dev/sda1 : start=       63, size=  4208967, Id=83
> /dev/sda2 : start=  4209030, size=  4209030, Id=83
> /dev/sda3 : start=  8418060, size=313251435, Id=83
> /dev/sda4 : start=        0, size=        0, Id= 0

What if the partition size is smaller; does that make the problem go
away?  If so, can you do a binary search on the partition size where
the problem appears?

And what can you say about the SATA driver you were using; were all of
the machines that you tested this on using the same SATA controller
and same driver?  

Obviously if this were a generic kernel problem, we'd been hearing
about this from a lot more people.  So there has to be something
unique to your setup, and we need to figure out what that might happen
to be.

					- Ted
