Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbYDPWPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbYDPWPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYDPWPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:15:30 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50354 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbYDPWP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:15:29 -0400
Date: Wed, 16 Apr 2008 15:15:24 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       hpa@zytor.com, Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH]: Propagate error code from devpts_pty_new
Message-ID: <20080416221524.GA7112@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [PATCH]: Propagate error code from devpts_pty_new

Have ptmx_open() propagate any error code returned by devpts_pty_new()
(which returns either 0 or -ENOMEM anyway).

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
---
 drivers/char/tty_io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: 2.6.25-rc8-mm2/drivers/char/tty_io.c
===================================================================
--- 2.6.25-rc8-mm2.orig/drivers/char/tty_io.c	2008-04-16 09:38:23.000000000 -0700
+++ 2.6.25-rc8-mm2/drivers/char/tty_io.c	2008-04-16 09:51:11.000000000 -0700
@@ -2835,8 +2835,8 @@ static int ptmx_open(struct inode *inode
 	filp->private_data = tty;
 	file_move(filp, &tty->tty_files);
 
-	retval = -ENOMEM;
-	if (devpts_pty_new(tty->link))
+	retval = devpts_pty_new(tty->link);
+	if (retval)
 		goto out1;
 
 	check_tty_count(tty, "tty_open");
