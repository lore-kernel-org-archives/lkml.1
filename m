Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbXLETTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbXLETTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbXLETTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:19:40 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:10406 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbXLETTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:19:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=Yo6ooc4l3p+0ynZmaJvZ76cVC7gNbykgj4ajDVr00kaZ2J0+D1mDoIDmWMX1joqOjouUq2zx3iA60hYKjkXUomO42+95De1qGLn4rm6ocHR/MoHZJbqje+FcQqWlHr0ZTY/xg6JWJO18a58UK5xUpuahZouwPknNumkicALDg5k=
From: Denis Cheng <crquan@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/20] drivers/edac/: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Thu,  6 Dec 2007 03:19:13 +0800
Message-Id: <1196882353-18827-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/edac/edac_device.c |    2 +-
 drivers/edac/edac_mc.c     |    2 +-
 drivers/edac/edac_pci.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index f3690a6..6f0b522 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -36,7 +36,7 @@
  * is protected by the 'device_ctls_mutex' lock
  */
 static DEFINE_MUTEX(device_ctls_mutex);
-static struct list_head edac_device_list = LIST_HEAD_INIT(edac_device_list);
+static LIST_HEAD(edac_device_list);
 
 #ifdef CONFIG_EDAC_DEBUG
 static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 063a1bf..9cd778f 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -36,7 +36,7 @@
 
 /* lock to memory controller's control array */
 static DEFINE_MUTEX(mem_ctls_mutex);
-static struct list_head mc_devices = LIST_HEAD_INIT(mc_devices);
+static LIST_HEAD(mc_devices);
 
 #ifdef CONFIG_EDAC_DEBUG
 
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 5dee9f5..dabba2d 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -29,7 +29,7 @@
 #include "edac_module.h"
 
 static DEFINE_MUTEX(edac_pci_ctls_mutex);
-static struct list_head edac_pci_list = LIST_HEAD_INIT(edac_pci_list);
+static LIST_HEAD(edac_pci_list);
 
 /*
  * edac_pci_alloc_ctl_info
-- 
1.5.3.4

