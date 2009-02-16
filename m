Return-Path: <linux-kernel-owner+w=401wt.eu-S1757678AbZBPM5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678AbZBPM5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 07:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZBPM53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 07:57:29 -0500
Received: from verein.lst.de ([213.95.11.210]:35410 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbZBPM52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:57:28 -0500
Date: Mon, 16 Feb 2009 13:57:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fix FREEZE/THAW compat_ioctl regression
Message-ID: <20090216125725.GA3420@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40,UPPERCASE_25_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8e961870bb9804110d5c8211d5d9d500451c4518 removed the FREEZE/THAW
handling in xfs_compat_ioctl but never added any compat handler back, so
now any freeze/thaw request from a 32-bit binary ond 64-bit userspace
will fail.

As these ioctls are 32/64-bit compatible two simple COMPATIBLE_IOCTL
entries in fs/compat_ioctl.c will do the job.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/compat_ioctl.c
===================================================================
--- xfs.orig/fs/compat_ioctl.c	2009-02-16 12:48:23.000000000 +0000
+++ xfs/fs/compat_ioctl.c	2009-02-16 12:49:34.000000000 +0000
@@ -1913,6 +1913,9 @@
 /* 0x00 */
 COMPATIBLE_IOCTL(FIBMAP)
 COMPATIBLE_IOCTL(FIGETBSZ)
+/* 'X' - originally XFS but some now in the VFS */
+COMPATIBLE_IOCTL(FIFREEZE)
+COMPATIBLE_IOCTL(FITHAW)
 /* RAID */
 COMPATIBLE_IOCTL(RAID_VERSION)
 COMPATIBLE_IOCTL(GET_ARRAY_INFO)
