Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbYKPKWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbYKPKWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 05:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYKPKWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 05:22:30 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:53655 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYKPKW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 05:22:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=braHdISFfAUCHqHzMOtzwRaX9AjTSLBYG5o19nClagsK8JBg8vjT7xPDgAaX3TxRiN
         w6+G9WDKLcDEjaJdr1yqnk/68mEL2S/lsz4Fpc9EWgRDt657S8J4xRTZ6MJ4IqEsaUax
         AElhSvzRHBhFYKGuLRHZV42D8skcgcSlnGthA=
From: tom.leiming@gmail.com
To: kay.sievers@vrfy.org, greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] kernel/ksysfs.c:fix dependence on CONFIG_NET
Date: Sun, 16 Nov 2008 18:22:09 +0800
Message-Id: <1226830929-6610-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Access to uevent_seqnum and uevent_helper does not need to
depend on CONFIG_NET, so remove it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/ksysfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 08dd8ed..528dd78 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -24,7 +24,7 @@ static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 static struct kobj_attribute _name##_attr = \
 	__ATTR(_name, 0644, _name##_show, _name##_store)
 
-#if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
+#if defined(CONFIG_HOTPLUG)
 /* current uevent sequence number */
 static ssize_t uevent_seqnum_show(struct kobject *kobj,
 				  struct kobj_attribute *attr, char *buf)
@@ -137,7 +137,7 @@ struct kobject *kernel_kobj;
 EXPORT_SYMBOL_GPL(kernel_kobj);
 
 static struct attribute * kernel_attrs[] = {
-#if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
+#if defined(CONFIG_HOTPLUG)
 	&uevent_seqnum_attr.attr,
 	&uevent_helper_attr.attr,
 #endif
-- 
1.6.0

