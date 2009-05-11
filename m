Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbZEKGRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbZEKGRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 02:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZEKGRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 02:17:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:4461 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZEKGRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 02:17:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=wsRlRIkLiz3WDe/gzvdQq1iRNuwk/IOQzLhPmXICAwNkocB6BnTh0CEOlLKyxD5UQH
         rSt+HuSg6DkwOJm8E6aD0XoyeXtpZsk/jt1qcWhu+S6ECrR4Y2QufoBaIjZfayW9/zRG
         miXYhY+Yv4xFbuVosESd3ACwPLnSpgWb1Xf6k=
MIME-Version: 1.0
Date: Mon, 11 May 2009 14:17:45 +0800
Message-ID: <a8e1da0905102317n1be27da2lc9fd4dc1265b12ce@mail.gmail.com>
Subject: [PATCH 2/3] kobject : make kset_create check kobject_set_name return 
	value
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kset_create should check the kobject_set_name return value.

Add the return value checking code.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
lib/kobject.c |    7 ++++++-
1 file changed, 6 insertions(+), 1 deletion(-)

diff -uprN linux.old/lib/kobject.c linux.new/lib/kobject.c
--- linux.old/lib/kobject.c	2009-05-11 13:59:01.000000000 +0800
+++ linux.new/lib/kobject.c	2009-05-11 14:00:39.000000000 +0800
@@ -793,11 +793,16 @@ static struct kset *kset_create(const ch
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
