Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbYGHLu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbYGHLu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 07:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYGHLuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 07:50:20 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:46638 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbYGHLuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 07:50:18 -0400
Subject: [PATCH] CONFIG_KMOD needs to be default y
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Tomas Winkler <tomasw@gmail.com>, rusty <rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 13:49:31 +0200
Message-Id: <1215517771.9610.28.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Far too many people configure their kernel without CONFIG_KMOD
and then complain that wireless breaks, thanks to Herbert Xu for
pointing me to this.

This patch makes CONFIG_KMOD default to "y" and adds a warning
that people should not turn it off.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
Maybe it should even depend on EMBEDDED? Who needs this option off
in the first place?

 init/Kconfig |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- everything.orig/init/Kconfig	2008-07-08 13:42:10.000000000 +0200
+++ everything/init/Kconfig	2008-07-08 13:43:41.000000000 +0200
@@ -895,6 +895,7 @@ config MODULE_SRCVERSION_ALL
 config KMOD
 	bool "Automatic kernel module loading"
 	depends on MODULES
+	default y
 	help
 	  Normally when you have selected some parts of the kernel to
 	  be created as kernel modules, you must load them (using the
@@ -902,7 +903,12 @@ config KMOD
 	  here, some parts of the kernel will be able to load modules
 	  automatically: when a part of the kernel needs a module, it
 	  runs modprobe with the appropriate arguments, thereby
-	  loading the module if it is available.  If unsure, say Y.
+	  loading the module if it is available.
+
+	  Do not say N unless you know you do not need it, and expect
+	  wireless, crypto and other things to break in this case.
+
+	  Say Y.
 
 config STOP_MACHINE
 	bool


