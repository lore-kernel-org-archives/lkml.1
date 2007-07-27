Return-Path: <linux-kernel-owner+w=401wt.eu-S937350AbXG0Onh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937350AbXG0Onh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 10:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761374AbXG0Ona
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 10:43:30 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:20627 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761506AbXG0On3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 10:43:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:from;
        b=ORiYqYQsM62Iqngu3NGJvaczlFdO3lgxS2xiMdheR/Aqn9s0b4WqLVqdgWbeS8HhEVz6IEDjtKNRUlkqD9VNIOnffKP4YohJ3HklkyLkLNHaIZMuY2/i0mmp+UOJDz+frVkNkp6odaIcpsvW1gD/vpRtFLJXQxrxLkzh7Xzhy8s=
Date: Fri, 27 Jul 2007 10:43:22 -0400 (EDT)
To: linux-kernel@vger.kernel.org
cc: torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: RE: [PATCH] TSDEV - Don't flood dmesg with removal warnings
Message-ID: <Pine.LNX.4.64.0707271038100.5691@parag-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: Parag Warudkar <parag.warudkar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore my previous whitespace damaged patch. This one should be good.

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

--- linux-git/drivers/input/tsdev.c.orig	2007-07-27 10:32:51.000000000 -0400
+++ linux-git/drivers/input/tsdev.c	2007-07-27 10:34:46.000000000 -0400
@@ -154,10 +154,6 @@
  	struct tsdev *tsdev;
  	int error;

-	printk(KERN_WARNING "tsdev (compaq touchscreen emulation) is scheduled "
-		"for removal.\nSee Documentation/feature-removal-schedule.txt "
-		"for details.\n");
-
  	if (i >= TSDEV_MINORS)
  		return -ENODEV;

@@ -521,6 +517,9 @@

  static int __init tsdev_init(void)
  {
+	printk(KERN_WARNING "tsdev (compaq touchscreen emulation) is scheduled "
+		"for removal.\nSee Documentation/feature-removal-schedule.txt "
+		"for details.\n");
  	return input_register_handler(&tsdev_handler);
  }

