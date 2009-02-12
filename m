Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbZBLKiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbZBLKiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbZBLKiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:38:05 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:45860 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbZBLKiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:38:03 -0500
Subject: util-linux: Add explanation for new mount options flushonfsync and
	noflushonfsync to mount(8) man page
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com,
       fernando@kic.ac.jp
In-Reply-To: <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
References: <20090114165952.GH6222@mit.edu>
	 <1232021211.14626.19.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090115234544.GA7579@duck.suse.cz>
	 <1232109069.13775.35.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232114101.13775.63.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090116163039.GE10617@duck.suse.cz>
	 <1232185639.4831.18.camel@sebastian.kern.oss.ntt.co.jp>
	 <1232186449.4831.29.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090119120349.GA10193@duck.suse.cz>
	 <1233135913.5399.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20090128095518.GA16554@duck.suse.cz>
	 <1234434811.15270.7.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 12 Feb 2009 19:38:01 +0900
Message-Id: <1234435081.15433.10.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urp mount-orig/mount.8 mount/mount.8
--- mount-orig/mount.8	2009-01-29 15:50:50.000000000 +0900
+++ mount/mount.8	2009-01-29 15:40:39.000000000 +0900
@@ -649,6 +649,18 @@ current modify or change time. (Similar 
 mutt or other applications that need to know if a file has been read
 since the last time it was modified.)
 .TP
+.B flushonfsync
+Force block device flush on fsync()/fdatasync(). When using storage equipped
+with write caches that can be explicitly flushed by the kernel, this guarantees
+that the data/metadata actually made it to the physical media after invoking
+the respective file data/metadata synchronization system call.
+.TP
+.B noflushonfsync
+Do not force a flush of the backing device's write cache when a file
+data/metadata synchronization system call is executed. Unless the device is
+equipped with a battery-backup write cache, this behavior can cause data loss
+and/or file system corruption in the event of a power failure.
+.TP
 .B noauto
 Can only be mounted explicitly (i.e., the
 .B \-a


