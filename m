Return-Path: <linux-kernel-owner+w=401wt.eu-S1761007AbXITIMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007AbXITIMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbXITIGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:20 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:34681 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722AbXITIF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=E82bTlWjpSXRSbEXzbAeTAO8R6KKzyEu1hbI3L8Mpf0epcekv3jeS/pvQ1cJZitHH8QWsxX+fNk++EPuC1vANsWiH7NROC6epqPczhz5ca8ucYjk68P7LO3yOmS9LIGzTqrAU7d1DlIILE9ELz9N5cAhb1sT9nGcZfJ88eY2F+8=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 18/22] kobject: implement __kobject_set_name()
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:41 +0900
Message-Id: <11902755413676-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Implement __kobject_set_name() which takes pre-allocated @new_name and
renames the kobject without failing.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 include/linux/kobject.h |    1 +
 lib/kobject.c           |   13 +++++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index a8a84fc..f7a7734 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -68,6 +68,7 @@ struct kobject {
 	struct sysfs_dirent	* sd;
 };
 
+extern void __kobject_set_name(struct kobject *kobj, const char *new_name);
 extern int kobject_set_name(struct kobject *, const char *, ...)
 	__attribute__((format(printf,2,3)));
 
diff --git a/lib/kobject.c b/lib/kobject.c
index a280c62..1623125 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -230,6 +230,19 @@ int kobject_register(struct kobject * kobj)
 	return error;
 }
 
+/**
+ *	__kobject_set_name - Set the name of an object to preallocated string
+ *	@kobj:		object.
+ *	@new_name:	pointer to pre-allocated string for the new name
+ *
+ *	Set the name of @kobj to @new_name.  @new_name is used
+ *	directly and will be freed using kfree() on @kobj release.
+ */
+void __kobject_set_name(struct kobject *kobj, const char *new_name)
+{
+	kfree(kobj->k_name);
+	kobj->k_name = new_name;
+}
 
 /**
  *	kobject_set_name - Set the name of an object
-- 
1.5.0.3


