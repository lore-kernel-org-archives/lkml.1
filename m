Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYLIUxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYLIUxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYLIUxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:53:45 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:42553 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbYLIUxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:53:44 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Jeff Garzik <jgarzik@redhat.com>,
       Alexandru Romanescu <a_romanescu@yahoo.co.uk>,
       Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] DMI: add dmi_match
Date: Tue,  9 Dec 2008 21:52:27 +0100
Message-Id: <1228855948-22886-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.5
In-Reply-To: <493E0689.6020302@garzik.org>
References: <493E0689.6020302@garzik.org>
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
 include/linux/dmi.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index 2bfda17..9bdb4b9 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -48,6 +48,21 @@ extern int dmi_name_in_serial(const char *str);
 extern int dmi_available;
 extern int dmi_walk(void (*decode)(const struct dmi_header *));
 
+/**
+ * dmi_match - compare string to the dmi field (if exists)
+ *
+ * Returns true if requested field equals to str (including NULL).
+ */
+static inline bool dmi_match(enum dmi_field f, const char *str)
+{
+	const char *info = dmi_get_system_info(f);
+
+	if (info == NULL || str == NULL)
+		return info == str;
+
+	return !strcmp(info, str);
+}
+
 #else
 
 static inline int dmi_check_system(const struct dmi_system_id *list) { return 0; }
@@ -61,6 +76,8 @@ static inline int dmi_name_in_serial(const char *s) { return 0; }
 #define dmi_available 0
 static inline int dmi_walk(void (*decode)(const struct dmi_header *))
 	{ return -1; }
+static inline bool dmi_match(enum dmi_field f, const char *str)
+	{ return false; }
 
 #endif
 
-- 
1.6.0.5

