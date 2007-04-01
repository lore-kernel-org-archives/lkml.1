Return-Path: <linux-kernel-owner+w=401wt.eu-S933782AbXDASPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbXDASPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933790AbXDASP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:15:29 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:39402 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933782AbXDASPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:15:25 -0400
Date: Sun, 1 Apr 2007 20:14:40 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 5/16] fix-kthread-niceness.diff
In-Reply-To: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704012003580.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix kevent's childs priority greedy-ness. Such tasks were always scheduled
at nice level -5 and, at that time, udev stole us the CPU time with -5.

Already posted at http://lkml.org/lkml/2005/1/10/85

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Chris Wright <chrisw@sous-sol.org>

 kmod.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.21-rc5/kernel/kmod.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/kmod.c
+++ linux-2.6.21-rc5/kernel/kmod.c
@@ -165,6 +165,7 @@ static int ____call_usermodehelper(void 
 
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed(current, CPU_MASK_ALL);
+	set_user_nice(current, 0);
 
 	retval = -EPERM;
 	if (current->fs->root)
#<EOF>
