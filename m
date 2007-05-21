Return-Path: <linux-kernel-owner+w=401wt.eu-S1761326AbXEUW6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326AbXEUW6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbXEUW6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:58:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:43265 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756141AbXEUW6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:58:03 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX18XCls47HIXwiXj1stoJq7RYxhnGh/N55Ifej0AbV
	UlL1yExra5Vmk6
Date: Tue, 22 May 2007 00:57:56 +0200
From: Eric Sesterhenn / Snakebyte <snakebyte@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: zaitcev@redhat.com
Subject: [Patch] Off by one in floppy.c
Message-ID: <20070521225755.GC16194@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.22-rc1 (i686)
X-Uptime: 00:54:21 up 14:53,  4 users,  load average: 0.62, 1.02, 1.03
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

another coverity patch i forgot to resend,
original thread here
http://marc.info/?l=linux-kernel&m=115144559823592&w=2

In case drive == N_DRIVE, we get one past the drive_params array.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>


--- linux-2.6/drivers/block/floppy.c.orig	2007-05-22 00:54:03.000000000 +0200
+++ linux-2.6/drivers/block/floppy.c	2007-05-22 00:54:18.000000000 +0200
@@ -670,7 +670,7 @@ static void __reschedule_timeout(int dri
 	if (drive == current_reqD)
 		drive = current_drive;
 	del_timer(&fd_timeout);
-	if (drive < 0 || drive > N_DRIVE) {
+	if (drive < 0 || drive >= N_DRIVE) {
 		fd_timeout.expires = jiffies + 20UL * HZ;
 		drive = 0;
 	} else

