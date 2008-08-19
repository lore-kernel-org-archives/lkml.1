Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbYHSJpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbYHSJpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYHSJpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:45:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:8497 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYHSJpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:45:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=rbBBfF95wVtnJYRG9kTybbD0sXPER2oaqoFEFMS+kmm3a5wZo1DxzNH9jvrxbOlEdx
         eu9dMGUlzjMMoeX01WqUcZACt+ruW8Ksmu+GyKKniuezB7mVjHg5FKaUG3qo6K4NQJ6g
         e2SL9UjGCqWFuonmAidua6lEGUf3lrYEjRWhk=
To: linux-kernel@vger.kernel.org
Cc: Russ Dill <Russ.Dill@gmail.com>
Subject: [PATCH] Remove debugfs entries upon unloading
Date: Tue, 19 Aug 2008 02:44:58 -0700
Message-Id: <1219139098-11033-1-git-send-email-Russ.Dill@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
From: Russ Dill <russ.dill@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exit function neglects to remove debugfs entries, leading to a BUG
on reload.

Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
---
 drivers/misc/acer-wmi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/acer-wmi.c b/drivers/misc/acer-wmi.c
index b2d9878..7a68351 100644
--- a/drivers/misc/acer-wmi.c
+++ b/drivers/misc/acer-wmi.c
@@ -1267,6 +1267,7 @@ error_platform_register:
 static void __exit acer_wmi_exit(void)
 {
 	remove_sysfs(acer_platform_device);
+	remove_debugfs();
 	platform_device_del(acer_platform_device);
 	platform_driver_unregister(&acer_platform_driver);
 
-- 
1.5.4.3

