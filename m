Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbYEIHYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbYEIHYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 03:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbYEIHXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 03:23:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:6619 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbYEIHXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 03:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=BFQ5wuZX0anehwDnKoRZEt/w+C2nnPsS3NHNO4YjhqnWQIGz0XxXNrtO6DAvqrS0TqJNuB2uuRy5ZdGYDzf1EOJ0sKoUrcqO305/fo48rh0KZTrCUhANfj3ou8t9ERWPbUJSXF+gc+eL0tZNe3LkrXebrBUBST30QSk/89KX3kk=
Date: Fri, 9 May 2008 15:24:08 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] struct class remove children list
Message-ID: <20080509072408.GC2740@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

because of the class_device was removed, now do the children list removing

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
drivers/base/class.c   |    1 -
include/linux/device.h |    1 -
2 files changed, 2 deletions(-)

diff -upr a/drivers/base/class.c b/drivers/base/class.c
--- a/drivers/base/class.c	2008-05-09 14:58:21.000000000 +0800
+++ b/drivers/base/class.c	2008-05-09 14:59:20.000000000 +0800
@@ -140,7 +140,6 @@ int class_register(struct class *cls)
 
 	pr_debug("device class '%s': registering\n", cls->name);
 
-	INIT_LIST_HEAD(&cls->children);
 	INIT_LIST_HEAD(&cls->devices);
 	INIT_LIST_HEAD(&cls->interfaces);
 	kset_init(&cls->class_dirs);
diff -upr a/include/linux/device.h b/include/linux/device.h
--- a/include/linux/device.h	2008-05-09 14:58:21.000000000 +0800
+++ b/include/linux/device.h	2008-05-09 14:58:47.000000000 +0800
@@ -183,7 +183,6 @@ struct class {
 	struct module		*owner;
 
 	struct kset		subsys;
-	struct list_head	children;
 	struct list_head	devices;
 	struct list_head	interfaces;
 	struct kset		class_dirs;
