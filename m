Return-Path: <linux-kernel-owner+w=401wt.eu-S935062AbZLQSNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935062AbZLQSNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932187AbZLQSNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:13:49 -0500
Received: from smtp.nokia.com ([192.100.122.233]:36401 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbZLQSNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:13:47 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 4/6] Driver core: Easy macros to encourage const attributes
Date: Thu, 17 Dec 2009 20:12:14 +0200
Message-Id: <1261073536-27396-5-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1261073536-27396-4-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1261073536-27396-1-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261073536-27396-2-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261073536-27396-3-git-send-email-ext-phil.2.carmody@nokia.com>
 <1261073536-27396-4-git-send-email-ext-phil.2.carmody@nokia.com>
X-OriginalArrivalTime: 17 Dec 2009 18:11:58.0678 (UTC) FILETIME=[6C689F60:01CA7F44]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's too easy to type DEVICE_ATTR and not think of adding
a 'const', make it just as easy to get const as part of the
macro.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 include/linux/device.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index d07f90f..ea8ced6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -165,6 +165,10 @@ struct driver_attribute {
 struct driver_attribute driver_attr_##_name =		\
 	__ATTR(_name, _mode, _show, _store)
 
+#define DRIVER_CATTR(_name, _mode, _show, _store)	\
+const struct driver_attribute driver_attr_##_name =	\
+	__ATTR(_name, _mode, _show, _store)
+
 extern int __must_check driver_create_file(struct device_driver *driver,
 					const struct driver_attribute *attr);
 extern void driver_remove_file(struct device_driver *driver,
@@ -318,6 +322,10 @@ struct device_attribute {
 #define DEVICE_ATTR(_name, _mode, _show, _store) \
 struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
 
+#define DEVICE_CATTR(_name, _mode, _show, _store) \
+const struct device_attribute dev_attr_##_name = \
+	__ATTR(_name, _mode, _show, _store)
+
 extern int __must_check device_create_file(struct device *device,
 					const struct device_attribute *entry);
 extern void device_remove_file(struct device *dev,
-- 
1.6.0.4

