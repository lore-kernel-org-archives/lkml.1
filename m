Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbZEKGTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbZEKGTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 02:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZEKGSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 02:18:55 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:2187 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbZEKGSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 02:18:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=t/JvvSD0QyhBocTntdyM5tkyz2jAysT9OELewpTRJQ7tABFB49SskJSMDA4urAzwdL
         rAoqbtfG68EJrVKk2phbniPofhvUAGepYBxH4TD1+4o7RUHkuSbzz/DktvivdQKsGEwQ
         zIRcvMwSixiR9sNeJYhHlzBsgRZYyR0K4RpV0=
MIME-Version: 1.0
Date: Mon, 11 May 2009 14:18:55 +0800
Message-ID: <a8e1da0905102318w52d331fbv60849dd362906296@mail.gmail.com>
Subject: [PATCH 3/3] driver-core : make sysdev_class_register check 
	kobject_set_name return value
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysdev_class_register should check the kobject_set_name return value.

Add the return value checking code.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
drivers/base/sys.c |    8 +++++++-
1 file changed, 7 insertions(+), 1 deletion(-)

diff -uprN linux.old/drivers/base/sys.c linux.new/drivers/base/sys.c
--- linux.old/drivers/base/sys.c	2009-05-11 13:59:16.000000000 +0800
+++ linux.new/drivers/base/sys.c	2009-05-11 14:01:16.000000000 +0800
@@ -131,6 +131,8 @@ static struct kset *system_kset;

 int sysdev_class_register(struct sysdev_class *cls)
 {
+	int retval;
+
 	pr_debug("Registering sysdev class '%s'\n", cls->name);

 	INIT_LIST_HEAD(&cls->drivers);
@@ -138,7 +140,11 @@ int sysdev_class_register(struct sysdev_
 	cls->kset.kobj.parent = &system_kset->kobj;
 	cls->kset.kobj.ktype = &ktype_sysdev_class;
 	cls->kset.kobj.kset = system_kset;
-	kobject_set_name(&cls->kset.kobj, cls->name);
+
+	retval = kobject_set_name(&cls->kset.kobj, cls->name);
+	if (retval)
+		return retval;
+
 	return kset_register(&cls->kset);
 }
