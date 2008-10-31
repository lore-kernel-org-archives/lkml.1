Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYJaPiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYJaPiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbYJaPiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:38:07 -0400
Received: from hobbit.corpit.ru ([81.13.33.150]:22350 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYJaPiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:38:06 -0400
Message-ID: <490B2659.9010304@msgid.tls.msk.ru>
Date: Fri, 31 Oct 2008 18:38:01 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: data corruption: revalidating a (removable) hdd/flash on re-insert
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make a long story short: is there a way to force kernel
to re-validate a replaced usb-connected hard drive (or a
flash) *automatically*?

Because right now, the kernel does not see that the drive
has been replaced, and uses *some* old cached values, which
results in random data corruption here and there, and other
similar odd things.

For example, I've an USB flash reader (Carry Computer Eng.,
Co., Ltd 6-in-1 Card Reader, but that's not really relevant).
Among other things it has a compact flash slot.  And I've
2 differently-size CF cards.

So I turn the machine on, insert one CF card, mount it, do
something with its vfat filesystem, umount it and remove
it.  Next I insert another card, and when trying to mount
it, the kernel says:

FAT: invalid media value (0x1e)
VFS: Can't find a valid FAT filesystem on dev sdb1.

When trying to run cfdisk for example, it complains that
"partition 0 ends after end of the drive" (or something
similar).

Sometimes the mount succeeds, but there are all sorts of
errors here in there, the filesystem is messed up, whith
parts of the files "from" just-removed card, and parts
from the new card.

And sure enough, when I, forgetting the issue, trying
to WRITE something to the card, it becomes almost 100%
messy...

What helps is to run, for example,

  blockdev --rereadpt /dev/sdb

manually, after replacing the card.

The first thing I was thinking of when saw the whole mess
is: there must be some process like hald/udev/whatever
messy subsystem du jur, which holds the device node open
and prevents the kernel from re-reading the drive by its
own as it correctly did in the past.  Nope, I've shut down
everything, and the same happens when only shell process
running INSTEAD of init (booting with init=/bin/sh option).

So at some point the kernel stopped noticing the drive
change in this configuration some time ago.  I can't say
when exactly, since I didn't use the card reader for over
a year, and certainly didn't try it with more than one
card in a row for even longer time.   It worked in the
past, that's for sure.  And it definitely does not work
(resulting in the above mess) with 2.6.25, 2.6.26 and 2.6.27.

Help?

Thanks!

/mjt
