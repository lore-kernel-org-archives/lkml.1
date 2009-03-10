Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZCJFR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZCJFR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbZCJFL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:57 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:28246 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbZCJFLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ALFq+bjT4Rw7YCi+/2CqrRJBXJ2FRxQt02yvDfvYJE1QoUpDebYiuBkst9EQlR2cMd
         ox7v7YVewF9zz1Dj7PpEe0IOo0K+XKWIqeNWPIpmoYDKNDt07/ZdkQlL/BFPqLNqws39
         Xg+ISefsxGf8BBn01h1QYieeCC8tTRQuZcomA=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>
Subject: [PATCH 19/25] [sysctl.c] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:44 -0500
Message-Id: <1236661850-8237-20-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-19-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-9-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-13-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-14-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-15-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-16-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-17-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-18-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-19-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 kernel/sysctl.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c5ef44f..ae992c4 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1513,8 +1513,7 @@ void sysctl_head_put(struct ctl_table_header *head)
 
 struct ctl_table_header *sysctl_head_grab(struct ctl_table_header *head)
 {
-	if (!head)
-		BUG();
+	BUG_ON(!head);
 	spin_lock(&sysctl_lock);
 	if (!use_table(head))
 		head = ERR_PTR(-ENOENT);
-- 
1.6.1.3

