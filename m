Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbYJQPxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbYJQPxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbYJQPwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:52:35 -0400
Received: from anchor-post-32.mail.demon.net ([194.217.242.90]:3981 "EHLO
	anchor-post-32.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753174AbYJQPwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:52:31 -0400
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Subject: [PATCH 00/16] Squashfs: compressed read-only filesystem
Message-Id: <E1KqrTW-0001x8-3h@dylan>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Fri, 17 Oct 2008 16:42:50 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a second attempt at mainlining Squashfs.  The first attempt was way
way back in early 2005 :-)  Since then the filesystem layout has undergone
two major revisions, and the kernel code has almost been completely
rewritten.  Both of these were to address the criticisms made at the original
attempt.

Summary of changes:
	1. Filesystem layout is now 64-bit, in theory filesystems and
	   files can be 2^64 in size.

	2. Filesystem is now fixed little-endian.

	3. "." and ".." are now returned by readdir.

	4. Sparse files are now supported.

	5. Filesystem is now exportable (NFS etc.).

	6. Datablocks up to 1 Mbyte are now supported.

Codewise all of the packed bit-fields and the swap macros have been removed in
favour of aligned structures and in-line swapping using leXX_to_cpu().  The
code has also been extensively restructured, reformatted to kernel coding
standards and commented.

Previously there was resistance to the inclusion of another compressed
filesystem when Linux already had cramfs.  There was pressure for a strong
case to be made for the inclusion of Squashfs.  Hopefully the case for
the inclusion of other compressed filesystems has now already been answered
over the last couple of years, however, it is worth listing the
features of Squashfs over cramfs, which is still the only read-only
compressed filesystem in mainline.

Max filesystem size: cramfs 16 Mbytes, Squashfs 64-bit filesystem
Max filesize: cramfs 16 Mbytes, Squashfs 64-bit filesystem
Block size: cramfs 4K, Squashfs default 128K, max 1Mbyte
Tail-end packing: cramfs no, Squashfs yes
Directory indexes: cramfs no, Squashfs yes
Compressed metadata: cramfs no, Squashfs yes
Hard link support: cramfs no, Squashfs yes
Support for "." and ".." in readdir: cramfs no, Squashfs yes
Real inode numbers: cramfs no, Squashfs yes.  Cramfs gives device inodes,
	fifo and empty directories the same inode of 1!
Exportable filesystem (NFS, etc.): cramfs no, Squashfs yes
Active maintenance: cramfs no (it is listed as orphaned, probably no active
	work for years), Squashfs yes

Sorry for the list formatting, but many email readers are very unforgiving
displaying tabbed lists and so I avoided them.

For those that want hard performance statistics
http://tree.celinuxforum.org/CelfPubWiki/SquashFsComparisons gives
a full comparison of the performance of Squashfs against cramfs, zisofs,
cloop and ext3.  I made these tests a number of years ago using Squashfs 2.1,
but they are still valid.  In fact the performance should now be better.

Cramfs is a limited filesystem, it's good for some embedded users but not now
much else, its layout and features hasn't changed in the eight years+ since
its release.  Squashfs, despite never being in mainline, has been actively
developed for over six years, and in that time has gone through four
layout revisions, each revision improving compression and performance where
limitations were found.  For an often dismissed filesystem, Squashfs has
advanced features such as metadata compression and tail-end packing for greater
compression, and directory indexes for faster dentry operations.

Despite not being in mainline, it is widely used.  It is packaged
by all major distributions (Ubuntu, Fedora, Debian, SUSE, Gentoo), it is used
on most LiveCDs, it is extensively used in embedded systems (STBs, routers,
mobile phones), and notably is used in such things as Splashtop and the
Amazon Kindle.

Anyway that's my case for inclusion.  If any readers want Squashfs
mainlined it's probably now a good time to offer support!

There are 16 patches in the patch set, and the patches are against the
latest linux-next tree (linux 2.6.27-next-20081016).

Finally, I would like to acknowledge the financial support of the Consumer
Embedded Linux Forum (CELF).  They've made it possible for me to spend the
last four months working full time on this mainlining attempt.

Phillip

