Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbYHUFsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbYHUFsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 01:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYHUFpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 01:45:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:28175 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbYHUFpt (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 01:45:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=FfZCWfNzv7r+fGo32FeUUDzm5OG7Jcz4BCellyL3W4ZysM6A2iBObPaLivgUpTBRlW
         87ercoLJ/KrbL8F+pRwuslhxVMGvF9KUVP68CbnrCjZ3y7L7uvsnERUAuLte9piP8aXd
         1vOGGuPpbJ5LBZIaYFpx0Fw7yKQBvQOEBhPxs=
Message-ID: <48AD011A.30505@gmail.com>
Date: Wed, 20 Aug 2008 22:46:02 -0700
From: Jared Hulbert <jaredeh@gmail.com>
Reply-To: jaredeh@gmail.com
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: [PATCH 09/10] AXFS: axfs_uml.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UML specific code for working with iomem 'devices'.  UML is handy for testing.

Signed-off-by: Jared Hulbert <jaredeh@gmail.com>
---
diff --git a/fs/axfs/axfs_uml.c b/fs/axfs/axfs_uml.c
new file mode 100644
index 0000000..7d479a0
--- /dev/null
+++ b/fs/axfs/axfs_uml.c
@@ -0,0 +1,47 @@
+/*
+ * Advanced XIP File System for Linux - AXFS
+ *   Readonly, compressed, and XIP filesystem for Linux systems big and small
+ *
+ * Copyright(c) 2008 Numonyx
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * Authors:
+ *  Jared Hulbert <jaredeh@gmail.com>
+ *
+ * Project url: http://axfs.sourceforge.net
+ *
+ * axfs_uml.c -
+ *   Allows axfs to a UML kernels find_iomem() interface as an XIP device or
+ *   dummy functions if this is not a UML build.
+ */
+
+#include <linux/axfs.h>
+#ifdef CONFIG_UML
+#include <mem_user.h>
+int axfs_get_uml_address(char *iomem, unsigned long *address,
+			 unsigned long *length)
+{
+	*address = find_iomem(iomem, length);
+	if (!(*address)) {
+		printk(KERN_DEBUG "axfs: find_iomem() failed\n");
+		return -EINVAL;
+	}
+
+	if (*length < PAGE_SIZE) {
+		printk(KERN_DEBUG
+		       "axfs: iomem() too small, must be at least %li Bytes\n",
+		       PAGE_SIZE);
+		return -EINVAL;
+	}
+	return 0;
+}
+#else
+int axfs_get_uml_address(char *iomem, unsigned long *address,
+			 unsigned long *length)
+{
+	return 0;
+}
+#endif /* CONFIG_UML */


