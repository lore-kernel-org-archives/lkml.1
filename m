Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0CBXd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:33:28 -0500
Received: from kroah.org ([198.145.64.141]:38679 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab0CBX3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 46/62] sysfs: Document sysfs_attr_init and sysfs_bin_attr_init
Date: Tue,  2 Mar 2010 15:28:45 -0800
Message-Id: <1267572541-410-46-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

I have added a new requirement to the external sysfs interface
that dynamically allocated sysfs attributes must call sysfs_attr_init
if lockdep is enabled.  For the time being callying sysfs_attr_init
is only mandatory if lockdep is enabled, so we can live with a few
unconverted instances until we find them all.  As this is part of
the public interface of sysfs it is a good idea to document these
pseudo functions so someone inspeciting the code can find out
what has happened.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sysfs.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 006c359..5b8f80f 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -36,6 +36,16 @@ struct attribute {
 #endif
 };
 
+/**
+ *	sysfs_attr_init - initialize a dynamically allocated sysfs attribute
+ *	@attr: struct attribute to initialize
+ *
+ *	Initialize a dynamically allocated struct attribute so we can
+ *	make lockdep happy.  This is a new requirement for attributes
+ *	and initially this is only needed when lockdep is enabled.
+ *	Lockdep gives a nice error when your attribute is added to
+ *	sysfs if you don't have this.
+ */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define sysfs_attr_init(attr)				\
 do {							\
@@ -90,6 +100,16 @@ struct bin_attribute {
 		    struct vm_area_struct *vma);
 };
 
+/**
+ *	sysfs_bin_attr_init - initialize a dynamically allocated bin_attribute
+ *	@attr: struct bin_attribute to initialize
+ *
+ *	Initialize a dynamically allocated struct bin_attribute so we
+ *	can make lockdep happy.  This is a new requirement for
+ *	attributes and initially this is only needed when lockdep is
+ *	enabled.  Lockdep gives a nice error when your attribute is
+ *	added to sysfs if you don't have this.
+ */
 #define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&bin_attr->attr)
 
 struct sysfs_ops {
-- 
1.7.0.1

