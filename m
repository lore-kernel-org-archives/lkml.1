Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbZLWLYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbZLWLYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 06:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZLWLYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 06:24:16 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:43169 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbZLWLYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 06:24:10 -0500
Date: Wed, 23 Dec 2009 06:23:41 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: any value in /proc/devices showing baseminor and minorct?
Message-ID: <alpine.LFD.2.00.0912230619430.17589@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  once upon a time, i tweaked fs/char_dev.c so that /proc/devices
would display not only the major number and device name, but the
baseminor and minorct values as well, thusly:

=====

diff --git a/fs/char_dev.c b/fs/char_dev.c
index a173551..57022d1 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -70,7 +70,8 @@ void chrdev_show(struct seq_file *f, off_t offset)
 	if (offset < CHRDEV_MAJOR_HASH_SIZE) {
 		mutex_lock(&chrdevs_lock);
 		for (cd = chrdevs[offset]; cd; cd = cd->next)
-			seq_printf(f, "%3d %s\n", cd->major, cd->name);
+			seq_printf(f, "%3d %s [%d, %d]\n", cd->major, cd->name,
+				cd->baseminor, cd->minorct);
 		mutex_unlock(&chrdevs_lock);
 	}
 }

=====

  is there any value in an enhancement like that?  i dreamed it up
based on one of the early examples from LDD3, where one has to use
"mknod" in user space to create the appropriate dev files based on the
kernel-space registration.  the major number is accessible, of course,
but the minor numbers were simply *assumed* to be 0->3.

  would printing out that extra info have any value?  or even making
it user-configurable?  or perhaps part of a debugging setting?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
