Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbXKVCoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbXKVCoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 21:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbXKVCnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 21:43:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:37766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbXKVCnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 21:43:10 -0500
From: Andi Kleen <ak@suse.de>
References: <20071122343.446909000@suse.de>
In-Reply-To: <20071122343.446909000@suse.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org,
       rusty@rustcorp.com.au
Subject: [PATCH RFC] [3/9] modpost: Declare the modpost error functions as printf like
Message-Id: <20071122024308.9B40114D68@wotan.suse.de>
Date: Thu, 22 Nov 2007 03:43:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This way gcc can warn for wrong format strings

---
 scripts/mod/modpost.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux/scripts/mod/modpost.c
===================================================================
--- linux.orig/scripts/mod/modpost.c
+++ linux/scripts/mod/modpost.c
@@ -33,7 +33,9 @@ enum export {
 	export_unused_gpl, export_gpl_future, export_unknown
 };
 
-void fatal(const char *fmt, ...)
+#define PRINTF __attribute__ ((format (printf, 1, 2)))
+
+PRINTF void fatal(const char *fmt, ...)
 {
 	va_list arglist;
 
@@ -46,7 +48,7 @@ void fatal(const char *fmt, ...)
 	exit(1);
 }
 
-void warn(const char *fmt, ...)
+PRINTF void warn(const char *fmt, ...)
 {
 	va_list arglist;
 
@@ -57,7 +59,7 @@ void warn(const char *fmt, ...)
 	va_end(arglist);
 }
 
-void merror(const char *fmt, ...)
+PRINTF void merror(const char *fmt, ...)
 {
 	va_list arglist;
 
