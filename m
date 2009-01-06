Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZAFWQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZAFWQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZAFWN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:13:28 -0500
Received: from kroah.org ([198.145.64.141]:51188 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753290AbZAFWNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:13:25 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/60] kernel/ksysfs.c:fix dependence on CONFIG_NET
Date: Tue,  6 Jan 2009 14:11:28 -0800
Message-Id: <1231279939-32728-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090106221123.GA32689@kroah.com>
References: <20090106221123.GA32689@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Access to uevent_seqnum and uevent_helper does not need to
depend on CONFIG_NET, so remove it.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.0.4

