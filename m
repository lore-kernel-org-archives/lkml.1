Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbZDKQQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbZDKQQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 12:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbZDKQQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 12:16:31 -0400
Received: from ti-out-0910.google.com ([209.85.142.190]:12651 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277AbZDKQQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 12:16:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YVnGK5ITmkMhOJMA+Ltt99ibDjZ+Lp2GlrJS1PAlRKneRTNylWM1FIYKsw9Iz/ZQyU
         exp2MPKyYyCA0Bx46EZ4xxacKZS2cFyb/TGCkmnVmq+lmPvGyhjuEszHMPE+TjN1snvF
         rEMqf0/ttlgIVe7Bzfi+MQK+IboUMK7glNE2Q=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] kobject: kzfree object in _release function
Date: Sun, 12 Apr 2009 00:16:26 +0800
Message-Id: <1239466586-29410-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

It helps to troubleshoot the __buggy__ case, in which
unreferenced objects are still accessed, using kzfree
to free objects safely in _release function.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 lib/kobject.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index a6dec32..cb5a562 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -597,7 +597,7 @@ void kobject_put(struct kobject *kobj)
 static void dynamic_kobj_release(struct kobject *kobj)
 {
 	pr_debug("kobject: (%p): %s\n", kobj, __func__);
-	kfree(kobj);
+	kzfree(kobj);
 }
 
 static struct kobj_type dynamic_kobj_ktype = {
@@ -762,7 +762,7 @@ static void kset_release(struct kobject *kobj)
 	struct kset *kset = container_of(kobj, struct kset, kobj);
 	pr_debug("kobject: '%s' (%p): %s\n",
 		 kobject_name(kobj), kobj, __func__);
-	kfree(kset);
+	kzfree(kset);
 }
 
 static struct kobj_type kset_ktype = {
-- 
1.6.0.GIT

