Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbYLJNJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbYLJNJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYLJNJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:09:20 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:56562 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYLJNJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:09:19 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>,
       Alexandru Romanescu <a_romanescu@yahoo.co.uk>,
       Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] DMI: add dmi_match
Date: Wed, 10 Dec 2008 14:07:21 +0100
Message-Id: <1228914442-30805-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.5
In-Reply-To: <493EE339.1070806@garzik.org>
References: <493EE339.1070806@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a wrapper for testing system_info which will handle also NULL
system infos.

This will be used by the ata PIIX driver.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Alexandru Romanescu <a_romanescu@yahoo.co.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/firmware/dmi_scan.c |   16 ++++++++++++++++
 include/linux/dmi.h         |    3 +++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 4a597d8..78b989d 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -582,3 +582,19 @@ int dmi_walk(void (*decode)(const struct dmi_header *))
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dmi_walk);
+
+/**
+ * dmi_match - compare a string to the dmi field (if exists)
+ *
+ * Returns true if the requested field equals to the str (including NULL).
+ */
+bool dmi_match(enum dmi_field f, const char *str)
+{
+	const char *info = dmi_get_system_info(f);
+
+	if (info == NULL || str == NULL)
+		return info == str;
+
+	return !strcmp(info, str);
+}
+EXPORT_SYMBOL_GPL(dmi_match);
diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index 2bfda17..3416190 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -47,6 +47,7 @@ extern int dmi_name_in_vendors(const char *str);
 extern int dmi_name_in_serial(const char *str);
 extern int dmi_available;
 extern int dmi_walk(void (*decode)(const struct dmi_header *));
+extern bool dmi_match(enum dmi_field f, const char *str);
 
 #else
 
@@ -61,6 +62,8 @@ static inline int dmi_name_in_serial(const char *s) { return 0; }
 #define dmi_available 0
 static inline int dmi_walk(void (*decode)(const struct dmi_header *))
 	{ return -1; }
+static inline bool dmi_match(enum dmi_field f, const char *str)
+	{ return false; }
 
 #endif
 
-- 
1.6.0.5

