Return-Path: <linux-kernel-owner+w=401wt.eu-S1031068AbXD2S7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031068AbXD2S7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 14:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031076AbXD2S7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 14:59:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:52328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031068AbXD2S7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 14:59:43 -0400
Subject: unprivileged mount problems: device permissions ignored, mount
	sharing
From: utz lehmann <lkml123@s2y4n2c.de>
To: Miklos Szeredi <miklos@szeredi.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 20:59:11 +0200
Message-Id: <1177873151.4343.29.camel@segv.aura.of.mankind>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/jGIKXNTNLT22L9lLVCLP8Im7uNpGmtfVhgyE
 8jes4yvM30LXaRDgkMPdpqsOeAItcU3Jf0EWMWnxLLh6xTvNVc
 JSUGgMvow1EOSoQwylV87DaTTgIxIEk
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I tried the unprivileged mount v5 patches with 2.6.21.1. I made some
experiments with normal filesystems (ext3, xfs, iso9660). I removed the
FS_SAFE checks for that.

Mounting and umounting as unprivileged user (user1) works, e.g.
(/mnt/user1 is a mount owned by user1)

[user1@segv ~]$ mmount -t xfs /dev/mapper/vg00-test /mnt/user1

But the device permissions are ignored. The unprivileged user can mount
the block device even there are no permissions to access it:

brw------- 1 root root 253, 5 Apr 29 18:32 /dev/mapper/vg00-test


And there is another problem with sharing the device (superblock?).
If user1 mount a device readonly:

[user1@segv ~]$ mmount -r -t xfs /dev/mapper/vg00-test /mnt/user1

Than root cannot mount the device rw:

[root@segv ~]# mount /dev/mapper/vg00-test /mnt/test/
mount: /dev/mapper/vg00-test already mounted or /mnt/test/ busy

Mounting ro works and than remounting rw work. But than /mnt/user1 is rw
too.

This can DoS e.g. the automounter mounting /dev/mapper/vg00-test rw.


utz


