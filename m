Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbYHLVZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbYHLVZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYHLVYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:24:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:53278 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbYHLVYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=omk0S3HFAKxayRpXpc5mpjM9QpiO2KN0w9aQRtGIlHpbT7jshy6jRqjIyXvC6DYDBI
         uyb76VVKvj9iRMXZdcTiiUxd5u7txVtv34mBcPPKqM85c1X97MQNTpi1YN1FeJbayNJO
         4GoROAP05JJY+dsoqVatGX6OYz5xsaOOud6+o=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       Len Brown <len.brown@intel.com>
Subject: [PATCH] suspend: fix section mismatch warning - register_nosave_region
Date: Tue, 12 Aug 2008 23:23:06 +0200
Message-Id: <1218576186-31442-4-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.text+0xe684): Section mismatch in reference from the function register_nosave_region() to the function .init.text:__register_nosave_region()
The function register_nosave_region() references
the function __init __register_nosave_region().
This is often because register_nosave_region lacks a __init
annotation or the annotation of __register_nosave_region is wrong.

register_nosave_region calls __init function and is called only from __init functions

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Len Brown <len.brown@intel.com>
---
 include/linux/suspend.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index c634350..2ce8207 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -217,11 +217,11 @@ struct platform_hibernation_ops {
 #ifdef CONFIG_HIBERNATION
 /* kernel/power/snapshot.c */
 extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
-static inline void register_nosave_region(unsigned long b, unsigned long e)
+static inline void __init register_nosave_region(unsigned long b, unsigned long e)
 {
 	__register_nosave_region(b, e, 0);
 }
-static inline void register_nosave_region_late(unsigned long b, unsigned long e)
+static inline void __init register_nosave_region_late(unsigned long b, unsigned long e)
 {
 	__register_nosave_region(b, e, 1);
 }
-- 
1.5.4.5

