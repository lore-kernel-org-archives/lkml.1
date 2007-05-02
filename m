Return-Path: <linux-kernel-owner+w=401wt.eu-S1767197AbXEBXHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767197AbXEBXHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767198AbXEBXHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:07:00 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37348 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767197AbXEBXG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:06:58 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: kai.germaschewski@gmx.de
Subject: [patch] sanitize linux/isdn_divertif.h for userspace
Date: Wed, 2 May 2007 19:07:06 -0400
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705021907.07157.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the isdn_divertif contains kernel-only references so ive wrapped them in 
__KERNEL__ and add proper #include statements

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 4ff0f57..ab2aaa2 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -91,7 +91,6 @@ header-y += ip_mp_alg.h
 header-y += ipsec.h
 header-y += ipx.h
 header-y += irda.h
-header-y += isdn_divertif.h
 header-y += iso_fs.h
 header-y += ixjuser.h
 header-y += jffs2.h
@@ -238,6 +237,7 @@ unifdef-y += ipv6.h
 unifdef-y += ipv6_route.h
 unifdef-y += isdn.h
 unifdef-y += isdnif.h
+unifdef-y += isdn_divertif.h
 unifdef-y += isdn_ppp.h
 unifdef-y += isicom.h
 unifdef-y += jbd.h
diff --git a/include/linux/isdn_divertif.h b/include/linux/isdn_divertif.h
index 0e7e44c..0df24b2 100644
--- a/include/linux/isdn_divertif.h
+++ b/include/linux/isdn_divertif.h
@@ -24,6 +24,10 @@
 #define DIVERT_REL_ERR  0x04  /* module not registered */
 #define DIVERT_REG_NAME isdn_register_divert
 
+#ifdef __KERNEL__
+#include <linux/isdnif.h>
+#include <linux/types.h>
+
 /***************************************************************/
 /* structure exchanging data between isdn hl and divert module */
 /***************************************************************/ 
@@ -40,3 +43,4 @@ typedef struct
 /* function register */
 /*********************/
 extern int DIVERT_REG_NAME(isdn_divert_if *);
+#endif
