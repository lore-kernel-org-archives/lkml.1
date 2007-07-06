Return-Path: <linux-kernel-owner+w=401wt.eu-S1762480AbXGFCAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480AbXGFCAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 22:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758857AbXGFCAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 22:00:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:52658 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137AbXGFCAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 22:00:44 -0400
Date: Fri, 6 Jul 2007 04:00:37 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [RFC][Patch] Allow not mounting a root fs
Message-ID: <Pine.LNX.4.58.0707060318160.26869@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19tNlV22x5Tq8sKBSybRTX8QI81bMz6JoJ4bns
 NnOqTVad3pPE1MqVRJPbElgOngb2vbBXn4Lbk8isVu96p9CK6k
 eQMkkHJGaIWo0w6/DlREg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the option to not mount another root filesystem 
by specifying root=initramfs.

TODO: Documentation
---

BTW: Is it possible to mount a tmpfs on / before extracting the cpio?


While I'm at it:

In init/do_mounts.c, mount_root(void):
ROOT_NFS: Is it desirable to use the floppy as a root device if nfs-root 
failed? If I tell my system to d A, i usually dislike it to do B instead.

Is the boot-from-floppy code here still usable, even though booting from 
floppy is no longer supported?



diff -X dontdiff -pruN 2.6.21.ori/init/do_mounts.c 2.6.21/init/do_mounts.c
--- 2.6.21.ori/init/do_mounts.c	2007-07-06 03:31:57.000000000 +0200
+++ 2.6.21/init/do_mounts.c	2007-07-06 03:27:33.000000000 +0200
@@ -427,6 +427,9 @@ void __init prepare_namespace(void)
 			mount_block_root(root_device_name, root_mountflags);
 			goto out;
 		}
+		if (!strncmp(root_device_name, "initramfs", 3)) {
+			goto out_nomount;
+		}
 		ROOT_DEV = name_to_dev_t(root_device_name);
 		if (strncmp(root_device_name, "/dev/", 5) == 0)
 			root_device_name += 5;
@@ -444,6 +447,7 @@ void __init prepare_namespace(void)
 out:
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot(".");
+out_nomount:
 	security_sb_post_mountroot();
 }
 
-- 
Top 100 things you don't want the sysadmin to say:
65. What do you mean /home was on that disk?  I umounted it!
