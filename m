Return-Path: <linux-kernel-owner+w=401wt.eu-S1762987AbYD2LQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762987AbYD2LQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbYD2LN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:13:29 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:18023 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbYD2LN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:13:28 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chas Williams <chas@cmf.nrl.navy.mil>
Subject: [PATCH 5/12] atm: assign PDE->data before gluing PDE into /proc tree
Date: Tue, 29 Apr 2008 15:13:15 +0400
Message-Id: <1209467602-20001-5-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1209467538.29647.11.camel@iris.sw.ru>
References: <1209467538.29647.11.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply replace proc_create and further data assigned with proc_create_data.
proc_atm_dev_ops holds proper referrence.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
---
 net/atm/proc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/atm/proc.c b/net/atm/proc.c
index 5c9f3d1..49487b3 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -417,12 +417,10 @@ int atm_proc_dev_register(struct atm_dev *dev)
 		goto err_out;
 	sprintf(dev->proc_name,"%s:%d",dev->type, dev->number);
 
-	dev->proc_entry = proc_create(dev->proc_name, 0, atm_proc_root,
-				      &proc_atm_dev_ops);
+	dev->proc_entry = proc_create_data(dev->proc_name, 0, atm_proc_root,
+					   &proc_atm_dev_ops, dev);
 	if (!dev->proc_entry)
 		goto err_free_name;
-	dev->proc_entry->data = dev;
-	dev->proc_entry->owner = THIS_MODULE;
 	return 0;
 err_free_name:
 	kfree(dev->proc_name);
-- 
1.5.3.rc5

