Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbYAXTgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbYAXTgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbYAXTez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:34:55 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46533 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721AbYAXTeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:31 -0500
Message-Id: <20080124193427.808900246@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:50 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 09/26] mount options: fix capifs
Content-Disposition: inline; filename=capifs_opts.patch
Cc: Karsten Keil <kkeil@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to capifs.

Use generic_show_options() and save the complete option string in
capifs_remount().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/drivers/isdn/capi/capifs.c
===================================================================
--- linux.orig/drivers/isdn/capi/capifs.c	2007-10-09 22:31:38.000000000 +0200
+++ linux/drivers/isdn/capi/capifs.c	2008-01-24 11:37:42.000000000 +0100
@@ -52,6 +52,7 @@ static int capifs_remount(struct super_b
 	gid_t gid = 0;
 	umode_t mode = 0600;
 	char *this_char;
+	char *new_opt = kstrdup(data, GFP_KERNEL);
 
 	this_char = NULL;
 	while ((this_char = strsep(&data, ",")) != NULL) {
@@ -72,11 +73,16 @@ static int capifs_remount(struct super_b
 			return -EINVAL;
 		}
 	}
+
+	kfree(s->s_options);
+	s->s_options = new_opt;
+
 	config.setuid  = setuid;
 	config.setgid  = setgid;
 	config.uid     = uid;
 	config.gid     = gid;
 	config.mode    = mode;
+
 	return 0;
 }
 
@@ -84,6 +90,7 @@ static struct super_operations capifs_so
 {
 	.statfs		= simple_statfs,
 	.remount_fs	= capifs_remount,
+	.show_options	= generic_show_options,
 };
 
 

--
