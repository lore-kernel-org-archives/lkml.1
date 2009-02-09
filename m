Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZBIH4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZBIH4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 02:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbZBIH4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 02:56:12 -0500
Received: from ozlabs.org ([203.10.76.45]:34168 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbZBIH4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 02:56:11 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 09 Feb 2009 18:22:26 +1030
CC: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 1/4] module_param: bool params should still work with #include <stdbool.h>
Message-Id: <20090209075610.3D86CDDDA2@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Code such as "module_param(foo, bool, 0400)" no longer compiles if one
includes stdbool.h: the ISO standard requires that this "#define bool
_Bool".

The fix is simple: define those as well.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -180,6 +180,11 @@ extern int param_get_bool(char *buffer, 
 extern int param_get_bool(char *buffer, struct kernel_param *kp);
 #define param_check_bool(name, p) __param_check(name, p, int)
 
+/* #include <stdbool.h> transforms module_param(foo, bool, 0). */
+#define param_set__Bool param_set_bool
+#define param_get__Bool param_get_bool
+#define param_check__Bool param_check_bool
+
 extern int param_set_invbool(const char *val, struct kernel_param *kp);
 extern int param_get_invbool(char *buffer, struct kernel_param *kp);
 #define param_check_invbool(name, p) __param_check(name, p, int)

