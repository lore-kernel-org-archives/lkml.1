Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbYJaP7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbYJaP7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYJaP7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:59:09 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:40528 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbYJaP7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:59:08 -0400
Date: Fri, 31 Oct 2008 11:59:01 -0400
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: data corruption: revalidating a (removable) hdd/flash on re-insert
Message-ID: <20081031155901.GE5682@csclub.uwaterloo.ca>
References: <490B2659.9010304@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490B2659.9010304@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 06:38:01PM +0300, Michael Tokarev wrote:
> To make a long story short: is there a way to force kernel
> to re-validate a replaced usb-connected hard drive (or a
> flash) *automatically*?
> 
> Because right now, the kernel does not see that the drive
> has been replaced, and uses *some* old cached values, which
> results in random data corruption here and there, and other
> similar odd things.
> 
> For example, I've an USB flash reader (Carry Computer Eng.,
> Co., Ltd 6-in-1 Card Reader, but that's not really relevant).
> Among other things it has a compact flash slot.  And I've
> 2 differently-size CF cards.
> 
> So I turn the machine on, insert one CF card, mount it, do
> something with its vfat filesystem, umount it and remove
> it.  Next I insert another card, and when trying to mount
> it, the kernel says:
> 
> FAT: invalid media value (0x1e)
> VFS: Can't find a valid FAT filesystem on dev sdb1.
> 
> When trying to run cfdisk for example, it complains that
> "partition 0 ends after end of the drive" (or something
> similar).
> 
> Sometimes the mount succeeds, but there are all sorts of
> errors here in there, the filesystem is messed up, whith
> parts of the files "from" just-removed card, and parts
> from the new card.
> 
> And sure enough, when I, forgetting the issue, trying
> to WRITE something to the card, it becomes almost 100%
> messy...
> 
> What helps is to run, for example,
> 
>   blockdev --rereadpt /dev/sdb
> 
> manually, after replacing the card.
> 
> The first thing I was thinking of when saw the whole mess
> is: there must be some process like hald/udev/whatever
> messy subsystem du jur, which holds the device node open
> and prevents the kernel from re-reading the drive by its
> own as it correctly did in the past.  Nope, I've shut down
> everything, and the same happens when only shell process
> running INSTEAD of init (booting with init=/bin/sh option).
> 
> So at some point the kernel stopped noticing the drive
> change in this configuration some time ago.  I can't say
> when exactly, since I didn't use the card reader for over
> a year, and certainly didn't try it with more than one
> card in a row for even longer time.   It worked in the
> past, that's for sure.  And it definitely does not work
> (resulting in the above mess) with 2.6.25, 2.6.26 and 2.6.27.

I have had this happen with a few usb flash card readers.  My solution
was to unplug the usb cable then swap the card and connect the usb cable
again.  In the end I went and bought a different card reader, which does
work correctly.

I highly suspect it is a mistake in the hardware causing the problem
given the vast majority of readers do work correctly already.

So far I have had no problems with a silverstone, mitsumi, dell (in
monitor), sandisk.  I have had a problem with a no name cheap "15 in
1" reader which I stopped using because plugging and unplugging got
annoying.

So my recommendation is get a non broken device.

-- 
Len Sorensen
