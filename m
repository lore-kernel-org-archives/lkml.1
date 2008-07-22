Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbYGVFlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbYGVFlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbYGVFZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:25:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:43371 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757482AbYGVFZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:25:42 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 60/79] kobject: reorder kobject to save space on 64 bit builds
Date: Mon, 21 Jul 2008 22:19:24 -0700
Message-Id: <1216703983-21448-60-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Kennedy <richard@rsk.demon.co.uk>

reorder kobject to save space on 64 bit builds.
shrinks from 72 to 64 bytes & moves allocated kobject to a smaller
slab.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kobject.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index d542faa..60f0d41 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -58,12 +58,12 @@ enum kobject_action {
 
 struct kobject {
 	const char		*name;
-	struct kref		kref;
 	struct list_head	entry;
 	struct kobject		*parent;
 	struct kset		*kset;
 	struct kobj_type	*ktype;
 	struct sysfs_dirent	*sd;
+	struct kref		kref;
 	unsigned int state_initialized:1;
 	unsigned int state_in_sysfs:1;
 	unsigned int state_add_uevent_sent:1;
-- 
1.5.6.3

