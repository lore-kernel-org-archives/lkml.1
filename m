Return-Path: <linux-kernel-owner+w=401wt.eu-S964985AbXG0OJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964985AbXG0OJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932652AbXG0OJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:09:25 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:48008 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564AbXG0OJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:09:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=T7x7ao1VOvYhFheciAodzU4A596X9fbLujps68DLYSQ1KEOnIkrdJ6MXnXXUqbz9XRVKSPICAJz6v1/3onIgslFepKfO24LTakLSZSvuhaxcEKnUmI02bn/lJmp5mG0Dn2Xizt8w+hFZDlrFB38mZz86t5WwiBVMwaGzvkXoHyM=
Message-ID: <46A9FC90.7080307@gmail.com>
Date: Fri, 27 Jul 2007 10:09:20 -0400
From: Parag Warudkar <parag.warudkar@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org
Subject: [PATCH] TSDEV - Don't flood dmesg with removal warnings
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tsdev.c warns about scheduled removal each time tsdev_open is called - 
So even for a default boot I get to see the warning 3 times -

[  340.537078] tsdev (compaq touchscreen emulation) is scheduled for 
removal.
[  340.537081] See Documentation/feature-removal-schedule.txt for details.
[  340.550314] tsdev (compaq touchscreen emulation) is scheduled for 
removal.
[  340.550318] See Documentation/feature-removal-schedule.txt for details.
[  340.565065] tsdev (compaq touchscreen emulation) is scheduled for 
removal.
[  340.565068] See Documentation/feature-removal-schedule.txt for details.

Move the warning to tsdev_init() from tsdev_open so we don't end up 
printing a large string in dmesg everytime tsdev_open is called.

Signed-Off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-git/drivers/input/tsdev.c.orig    2007-07-27 
09:57:14.000000000 -0400
+++ linux-git/drivers/input/tsdev.c    2007-07-27 09:58:09.000000000 -0400
@@ -154,10 +154,6 @@
     struct tsdev *tsdev;
     int error;
 
-    printk(KERN_WARNING "tsdev (compaq touchscreen emulation) is 
scheduled "
-        "for removal.\nSee Documentation/feature-removal-schedule.txt "
-        "for details.\n");
-
     if (i >= TSDEV_MINORS)
         return -ENODEV;
 
@@ -521,6 +517,9 @@
 
 static int __init tsdev_init(void)
 {
+    printk(KERN_WARNING "tsdev (compaq touchscreen emulation) is 
scheduled "
+        "for removal.\nSee Documentation/feature-removal-schedule.txt "
+        "for details.\n");
     return input_register_handler(&tsdev_handler);
 }
