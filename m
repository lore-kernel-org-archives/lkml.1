Return-Path: <linux-kernel-owner+w=401wt.eu-S1752091AbYIBL0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbYIBL0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 07:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYIBL0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 07:26:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60343 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYIBL0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 07:26:38 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080902126.215915333@firstfloor.org>
In-Reply-To: <20080902126.215915333@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/3] sysfs: Add utility macros for declaring generic extended sysdev attributes 
Message-Id: <20080902112635.3F0ED3E6A00@basil.firstfloor.org>
Date: Tue,  2 Sep 2008 13:26:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is similar to _SYSDEV_ULONG_ATTR, but allows to use 

Needed for followup patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/sysdev.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux/include/linux/sysdev.h
===================================================================
--- linux.orig/include/linux/sysdev.h
+++ linux/include/linux/sysdev.h
@@ -139,7 +139,12 @@ extern ssize_t sysdev_show_int(struct sy
 				char *);
 extern ssize_t sysdev_store_int(struct sys_device *,
 			struct sysdev_attribute *, const char *, size_t);
-
+#define _SYSDEV_EXT_ATTR(_name, _mode, _var, _show, _store)	\
+	{ _SYSDEV_ATTR(_name, _mode, _show, _store),		\
+	  &(_var) }
+#define SYSDEV_EXT_ATTR(_name, _mode, _var, _show, _store)	\
+	struct sysdev_ext_attribute attr_##_name =		\
+		_SYSDEV_EXT_ATTR(_name, _mode, _var, _show, _store);
 #define _SYSDEV_ULONG_ATTR(_name, _mode, _var)				\
 	{ _SYSDEV_ATTR(_name, _mode, sysdev_show_ulong, sysdev_store_ulong), \
 	  &(_var) }
