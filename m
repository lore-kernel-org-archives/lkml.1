Return-Path: <linux-kernel-owner+w=401wt.eu-S1764129AbYAYIEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764129AbYAYIEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764066AbYAYH7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:59:47 -0500
Received: from ns.suse.de ([195.135.220.2]:59319 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760209AbYAYH7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:40 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 134/196] Kobject: convert kernel/user.c to use kobject_init/add_ng()
Date: Thu, 24 Jan 2008 23:32:43 -0800
Message-Id: <1201246425-5058-55-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the code to use the new kobject functions, cleaning up the
logic in doing so.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/user.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 7f17e6e..ab4fd70 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -181,13 +181,12 @@ static int uids_user_create(struct user_struct *up)
 	int error;
 
 	memset(kobj, 0, sizeof(struct kobject));
-	kobj->ktype = &uids_ktype;
 	kobj->kset = uids_kset;
-	kobject_init(kobj);
-	kobject_set_name(&up->kobj, "%d", up->uid);
-	error = kobject_add(kobj);
-	if (error)
+	error = kobject_init_and_add(kobj, &uids_ktype, NULL, "%d", up->uid);
+	if (error) {
+		kobject_put(kobj);
 		goto done;
+	}
 
 	kobject_uevent(kobj, KOBJ_ADD);
 done:
-- 
1.5.3.8

