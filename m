Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbZGTSAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbZGTSAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZGTSAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:00:35 -0400
Received: from leb.cs.unibo.it ([130.136.1.102]:39021 "EHLO leb.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbZGTSAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:00:35 -0400
X-Greylist: delayed 1318 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 14:00:35 EDT
Date: Mon, 20 Jul 2009 19:38:35 +0200
From: Renzo Davoli <renzo@cs.unibo.it>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs/char_dev.c: remove useless loop
Message-ID: <20090720173834.GA14288@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two useless lines in fs/char_dev.c.

In register_chrdev there is a loop to change all '/' into '!' in the
kernel object name.
This code is useless as the same substitution is in kobject_set_name_vargs in
lib/kobject.c:
228         /* ewww... some of these buggers have '/' in the name ... */
229         while ((s = strchr(kobj->name, '/')))
230                 s[0] = '!';

kobject_set_name_vargs is called by kobject_set_name.
kobject_set_name is called just above the useless loop.

	renzo

Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
--
--- a/fs/char_dev.c	2009-07-20 19:06:51.000000000 +0200
+++ b/fs/char_dev.c	2009-07-20 19:14:26.000000000 +0200
@@ -278,8 +278,6 @@
 	cdev->owner = fops->owner;
 	cdev->ops = fops;
 	kobject_set_name(&cdev->kobj, "%s", name);
-	for (s = strchr(kobject_name(&cdev->kobj),'/'); s; s = strchr(s, '/'))
-		*s = '!';
 		
 	err = cdev_add(cdev, MKDEV(cd->major, 0), 256);
 	if (err)
