Return-Path: <linux-kernel-owner+w=401wt.eu-S1762799AbYBSAwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762799AbYBSAwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762407AbYBSAvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:51:54 -0500
Received: from smtp-out.google.com ([216.239.33.17]:58001 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762353AbYBSAvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:51:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=LdzVupPZy4zhKEp9iWr4ckVuGYGCEVoHCfFz1rCyKNmj5TrOPdYaE2KSpmHFzNnn2
	ZeXK3gE6AqpeMx5QGuldw==
Date: Mon, 18 Feb 2008 16:51:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] documentation: fix firmware_sample_firmware_class to
 build
In-Reply-To: <alpine.DEB.1.00.0802181629180.15109@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0802181650140.21008@chino.kir.corp.google.com>
References: <20080218162216.ee1501fd.randy.dunlap@oracle.com> <alpine.DEB.1.00.0802181629180.15109@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sysfs_remove_bin_file() to have a return value of void in the 
!CONFIG_SYSFS case, matching the return value of the same function with 
the opposite configuration.

Also moves unnecessary ';' in empty void functions.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/sysfs.h |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -93,7 +93,7 @@ int __must_check sysfs_create_file(struct kobject *kobj,
 				   const struct attribute *attr);
 int __must_check sysfs_chmod_file(struct kobject *kobj, struct attribute *attr,
 				  mode_t mode);
-void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr);
+void wsysfs_remove_file(struct kobject *kobj, const struct attribute *attr);
 
 int __must_check sysfs_create_bin_file(struct kobject *kobj,
 				       struct bin_attribute *attr);
@@ -131,7 +131,6 @@ static inline int sysfs_create_dir(struct kobject *kobj)
 
 static inline void sysfs_remove_dir(struct kobject *kobj)
 {
-	;
 }
 
 static inline int sysfs_rename_dir(struct kobject *kobj, const char *new_name)
@@ -160,7 +159,6 @@ static inline int sysfs_chmod_file(struct kobject *kobj,
 static inline void sysfs_remove_file(struct kobject *kobj,
 				     const struct attribute *attr)
 {
-	;
 }
 
 static inline int sysfs_create_bin_file(struct kobject *kobj,
@@ -169,10 +167,9 @@ static inline int sysfs_create_bin_file(struct kobject *kobj,
 	return 0;
 }
 
-static inline int sysfs_remove_bin_file(struct kobject *kobj,
-					struct bin_attribute *attr)
+static inline void sysfs_remove_bin_file(struct kobject *kobj,
+					 struct bin_attribute *attr)
 {
-	return 0;
 }
 
 static inline int sysfs_create_link(struct kobject *kobj,
@@ -183,7 +180,6 @@ static inline int sysfs_create_link(struct kobject *kobj,
 
 static inline void sysfs_remove_link(struct kobject *kobj, const char *name)
 {
-	;
 }
 
 static inline int sysfs_create_group(struct kobject *kobj,
@@ -195,7 +191,6 @@ static inline int sysfs_create_group(struct kobject *kobj,
 static inline void sysfs_remove_group(struct kobject *kobj,
 				      const struct attribute_group *grp)
 {
-	;
 }
 
 static inline int sysfs_add_file_to_group(struct kobject *kobj,
