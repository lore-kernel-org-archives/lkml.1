Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXLETRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXLETRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXLETQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:16:53 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:2572 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXLETQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:16:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=j3z83A/F9AEP/gxpiO11Xk4sxyIyJaovI8kzMxxtsHqBOr1Q+5caveCWkudViqNJfpFPeQtDzqYmdQJjPBMNMiIUkw2MereXrrerTCL4g0OXyMSnMtjCYahJolwZhcLaSZEjoBMAAkehEAY/ar+DN679w7g5ZNHI4tXxiCrmR30=
From: Denis Cheng <crquan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/20] drivers/char: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Thu,  6 Dec 2007 03:16:29 +0800
Message-Id: <1196882189-18805-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/char/hvc_console.c          |    2 +-
 drivers/char/hvcs.c                 |    2 +-
 drivers/char/ipmi/ipmi_msghandler.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 8252f86..9e64211 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -93,7 +93,7 @@ struct hvc_struct {
 };
 
 /* dynamic list of hvc_struct instances */
-static struct list_head hvc_structs = LIST_HEAD_INIT(hvc_structs);
+static LIST_HEAD(hvc_structs);
 
 /*
  * Protect the list of hvc_struct instances from inserts and removals during
diff --git a/drivers/char/hvcs.c b/drivers/char/hvcs.c
index 69d8866..ae60e0e 100644
--- a/drivers/char/hvcs.c
+++ b/drivers/char/hvcs.c
@@ -310,7 +310,7 @@ struct hvcs_struct {
 /* Required to back map a kobject to its containing object */
 #define from_kobj(kobj) container_of(kobj, struct hvcs_struct, kobj)
 
-static struct list_head hvcs_structs = LIST_HEAD_INIT(hvcs_structs);
+static LIST_HEAD(hvcs_structs);
 static DEFINE_SPINLOCK(hvcs_structs_lock);
 
 static void hvcs_unthrottle(struct tty_struct *tty);
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 5dc1265..d01c4ff 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -365,12 +365,12 @@ static struct device_driver ipmidriver = {
 };
 static DEFINE_MUTEX(ipmidriver_mutex);
 
-static struct list_head ipmi_interfaces = LIST_HEAD_INIT(ipmi_interfaces);
+static LIST_HEAD(ipmi_interfaces);
 static DEFINE_MUTEX(ipmi_interfaces_mutex);
 
 /* List of watchers that want to know when smi's are added and
    deleted. */
-static struct list_head smi_watchers = LIST_HEAD_INIT(smi_watchers);
+static LIST_HEAD(smi_watchers);
 static DEFINE_MUTEX(smi_watchers_mutex);
 
 
-- 
1.5.3.4

