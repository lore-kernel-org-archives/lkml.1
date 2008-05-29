Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYE2ST2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYE2ST2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYE2STR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:19:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbYE2STQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:19:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/6] Werror: Fix casting wrong size integer to pointer
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, bunk@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 29 May 2008 19:17:26 +0100
Message-ID: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix casting wrong size integer to pointer.  Smaller integers must be cast to
unsigned long then cast to a pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/drm/sis_mm.c        |    2 +-
 drivers/message/i2o/i2o_config.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/char/drm/sis_mm.c b/drivers/char/drm/sis_mm.c
index b387877..378b275 100644
--- a/drivers/char/drm/sis_mm.c
+++ b/drivers/char/drm/sis_mm.c
@@ -57,7 +57,7 @@ static void *sis_sman_mm_allocate(void *private, unsigned long size,
 	if (req.size == 0)
 		return NULL;
 	else
-		return (void *)~req.offset;
+		return (void *)(unsigned long)~req.offset;
 }
 
 static void sis_sman_mm_free(void *private, void *ref)
diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index c0fb77d..a1c83af 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -886,7 +886,7 @@ static int i2o_cfg_passthru(unsigned long arg)
 			    flag_count & 0x04000000 /*I2O_SGL_FLAGS_DIR */ ) {
 				// TODO 64bit fix
 				if (copy_from_user
-				    (p, (void __user *)sg[i].addr_bus,
+				    (p, (void __user *)(unsigned long)sg[i].addr_bus,
 				     sg_size)) {
 					printk(KERN_DEBUG
 					       "%s: Could not copy SG buf %d FROM user\n",
@@ -942,7 +942,7 @@ static int i2o_cfg_passthru(unsigned long arg)
 				sg_size = sg[j].flag_count & 0xffffff;
 				// TODO 64bit fix
 				if (copy_to_user
-				    ((void __user *)sg[j].addr_bus, sg_list[j],
+				    ((void __user *)(unsigned long)sg[j].addr_bus, sg_list[j],
 				     sg_size)) {
 					printk(KERN_WARNING
 					       "%s: Could not copy %p TO user %x\n",

