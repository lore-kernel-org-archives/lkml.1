Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbYFBKHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbYFBKHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYFBKHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:07:32 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:53921 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbYFBKHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:07:31 -0400
Subject: [PATCH] kobject: reorder kobject to save space on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 11:07:25 +0100
Message-Id: <1212401245.2966.8.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reorder kobject to save space on 64 bit builds.
shrinks from 76 to 64 bytes & moves allocated kobject to a smaller
slab. 
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----

Running successfully on 2.6.26-rc2 on my desktop AMD64.




diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index 39e709f..07124fc 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -59,12 +59,12 @@ enum kobject_action {
 
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


