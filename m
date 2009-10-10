Return-Path: <linux-kernel-owner+w=401wt.eu-S934825AbZJJUwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934825AbZJJUwM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 16:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934806AbZJJUwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 16:52:11 -0400
Received: from smtprelay11.ispgateway.de ([80.67.31.45]:39181 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934808AbZJJUwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 16:52:10 -0400
From: Bernhard Walle <bernhard@bwalle.de>
To: akpm@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Bernhard Walle <bernhard@bwalle.de>
Subject: [PATCH 3/5] Use vt_get_kmsg_redirect() and vt_set_kmsg_redirect()
Date: Sat, 10 Oct 2009 22:51:08 +0200
Message-Id: <1255207870-24496-4-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the only code file where kmsg_redirect is used (power/console.c) is
already protected by CONFIG_VT_CONSOLE, we use the new interface here
to be able to make kmsg_redirect static.


Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
---
 kernel/power/console.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/power/console.c b/kernel/power/console.c
index 5187136..df959d7 100644
--- a/kernel/power/console.c
+++ b/kernel/power/console.c
@@ -6,7 +6,7 @@
 
 #include <linux/vt_kern.h>
 #include <linux/kbd_kern.h>
-#include <linux/console.h>
+#include <linux/vt.h>
 #include <linux/module.h>
 #include "power.h"
 
@@ -21,8 +21,8 @@ int pm_prepare_console(void)
 	if (orig_fgconsole < 0)
 		return 1;
 
-	orig_kmsg = kmsg_redirect;
-	kmsg_redirect = SUSPEND_CONSOLE;
+	orig_kmsg = vt_get_kmsg_redirect();
+	vt_set_kmsg_redirect(SUSPEND_CONSOLE);
 	return 0;
 }
 
@@ -30,7 +30,7 @@ void pm_restore_console(void)
 {
 	if (orig_fgconsole >= 0) {
 		vt_move_to_console(orig_fgconsole, 0);
-		kmsg_redirect = orig_kmsg;
+		vt_set_kmsg_redirect(orig_kmsg);
 	}
 }
 #endif
-- 
1.6.3.3

