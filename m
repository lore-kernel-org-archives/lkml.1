Return-Path: <linux-kernel-owner+w=401wt.eu-S1764317AbYHEVSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764317AbYHEVSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757060AbYHEVSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:18:45 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:48911 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbYHEVSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:18:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=k9IuInR7+68fSuOEWHvBr9bySC+afaRsDpPJy342mT+z4Z33F3CqSJhRPES3b1IDit
         KBJVM9W/598OaJGLBnel9ad/Q8A68ChQmHU/AJbL8ddXB1Yaewyu2jOR9DXTEM49bihS
         ooc0sMd18KVrO3rE/sVUsKQf2jjrHTWiM71Go=
Date: Wed, 6 Aug 2008 01:18:37 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sparc: serio/i8042-sparcio.h: fix warning
Message-ID: <20080805211837.GE17320@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

sparc: i8042-sparcio.h: fix warning

drivers/input/serio/i8042-sparcio.h:95: warning: 'sparc_i8042_driver'
defined but not used

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/input/serio/i8042-sparcio.h |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/input/serio/i8042-sparcio.h b/drivers/input/serio/i8042-sparcio.h
index d9ca558..66bafe3 100644
--- a/drivers/input/serio/i8042-sparcio.h
+++ b/drivers/input/serio/i8042-sparcio.h
@@ -41,6 +41,8 @@ static inline void i8042_write_command(int val)
 	writeb(val, kbd_iobase + 0x64UL);
 }
 
+#ifdef CONFIG_PCI
+
 #define OBP_PS2KBD_NAME1	"kb_ps2"
 #define OBP_PS2KBD_NAME2	"keyboard"
 #define OBP_PS2MS_NAME1		"kdmouse"
@@ -101,9 +103,6 @@ static struct of_platform_driver sparc_i8042_driver = {
 
 static int __init i8042_platform_init(void)
 {
-#ifndef CONFIG_PCI
-	return -ENODEV;
-#else
 	struct device_node *root = of_find_node_by_path("/");
 
 	if (!strcmp(root->name, "SUNW,JavaStation-1")) {
@@ -131,17 +130,25 @@ static int __init i8042_platform_init(void)
 	i8042_reset = 1;
 
 	return 0;
-#endif /* CONFIG_PCI */
 }
 
 static inline void i8042_platform_exit(void)
 {
-#ifdef CONFIG_PCI
 	struct device_node *root = of_find_node_by_path("/");
 
 	if (strcmp(root->name, "SUNW,JavaStation-1"))
 		of_unregister_driver(&sparc_i8042_driver);
-#endif
 }
 
+#else /* !CONFIG_PCI */
+static int __init i8042_platform_init(void)
+{
+	return -ENODEV;
+}
+
+static inline void i8042_platform_exit(void)
+{
+}
+#endif /* !CONFIG_PCI */
+
 #endif /* _I8042_SPARCIO_H */
