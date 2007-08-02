Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbXHBDKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbXHBDKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 23:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbXHBDKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 23:10:06 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:39352 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbXHBDKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 23:10:04 -0400
X-IronPort-AV: i="4.19,210,1183348800"; 
   d="scan'208"; a="36173793:sNHT26486404"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Greg KH" <gregkh@suse.de>
Subject: [PATCH] debugfs helper for decimal challenged
Date: Wed, 1 Aug 2007 23:13:51 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Mike Frysinger" <vapier.adi@gmail.com>
References: <200708011752.58481.rgetz@blackfin.uclinux.org> <20070801222523.GA26289@suse.de>
In-Reply-To: <20070801222523.GA26289@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200708012313.51933.rgetz@blackfin.uclinux.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Aug 2007 03:10:02.0843 (UTC) FILETIME=[9E4C82B0:01C7D4B2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>

Allows debugfs helper functions to have a hex output, rather than just decimal
 
Signed-off-by:  Robin Getz <rgetz@blackfin.uclinux.org>
---
 fs/debugfs/file.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: fs/debugfs/file.c
===================================================================
--- fs/debugfs/file.c	(revision 3529)
+++ fs/debugfs/file.c	(working copy)
@@ -179,6 +179,42 @@
 }
 EXPORT_SYMBOL_GPL(debugfs_create_u32);
 
+DEFINE_SIMPLE_ATTRIBUTE(fops_x8, debugfs_u8_get, debugfs_u8_set, "0x%02llx\n");
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_x16, debugfs_u16_get, debugfs_u16_set, "0x%04llx\n");
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_x32, debugfs_u32_get, debugfs_u32_set, "0x%08llx\n");
+
+/**
+ * debugfs_create_x8 - create a debugfs file that is used to read and write an unsigned 8-bit value
+ * debugfs_create_x16 - create a debugfs file that is used to read and write an unsigned 16-bit value
+ * debugfs_create_x32 - create a debugfs file that is used to read and write an unsigned 32-bit value
+ *
+ * These functions are exactly the same as the above functions, (but use a hex
+ * output for the decimal challenged) for details look at the above unsigned
+ * decimal functions.
+ */
+struct dentry *debugfs_create_x8(const char *name, mode_t mode,
+				 struct dentry *parent, u8 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_x8);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_x8);
+
+struct dentry *debugfs_create_x16(const char *name, mode_t mode,
+				 struct dentry *parent, u16 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_x16);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_x16);
+
+struct dentry *debugfs_create_x32(const char *name, mode_t mode,
+				 struct dentry *parent, u32 *value)
+{
+	return debugfs_create_file(name, mode, parent, value, &fops_x32);
+}
+EXPORT_SYMBOL_GPL(debugfs_create_x32);
+
 static ssize_t read_file_bool(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
