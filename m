Return-Path: <linux-kernel-owner+w=401wt.eu-S936203AbZFPFxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936203AbZFPFxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbZFPFu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:50:59 -0400
Received: from kroah.org ([198.145.64.141]:48314 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761471AbZFPFu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:50:58 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/64] kobject: make kset_create check kobject_set_name return value
Date: Mon, 15 Jun 2009 22:45:59 -0700
Message-Id: <1245131213-24168-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>

kset_create should check the kobject_set_name return value.

Add the return value checking code.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index bacf6fe..b512b74 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -793,11 +793,16 @@ static struct kset *kset_create(const char *name,
 				struct kobject *parent_kobj)
 {
 	struct kset *kset;
+	int retval;
 
 	kset = kzalloc(sizeof(*kset), GFP_KERNEL);
 	if (!kset)
 		return NULL;
-	kobject_set_name(&kset->kobj, name);
+	retval = kobject_set_name(&kset->kobj, name);
+	if (retval) {
+		kfree(kset);
+		return NULL;
+	}
 	kset->uevent_ops = uevent_ops;
 	kset->kobj.parent = parent_kobj;
 
-- 
1.6.3.2

