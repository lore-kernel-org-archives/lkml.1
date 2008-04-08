Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbYDHV7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbYDHV7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYDHV7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:59:37 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56292 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbYDHV7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:59:36 -0400
Date: Tue, 8 Apr 2008 14:58:18 -0700
From: sukadev@us.ibm.com
To: linux-kernel@vger.kernel.org
Cc: Containers <containers@lists.osdl.org>, clg@fr.ibm.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: [RFC][PATCH 1/7]: Propagate error code from devpts_pty_new
Message-ID: <20080408215818.GA9034@us.ibm.com>
References: <20080408215333.GA8799@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080408215333.GA8799@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [RFC][PATCH 1/7]: Propagate error code from devpts_pty_new

Have ptmx_open() propagate any error code returned by devpts_pty_new()
(which returns either 0 or -ENOMEM anyway).

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
---
 drivers/char/tty_io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: 2.6.25-rc8-mm1/drivers/char/tty_io.c
===================================================================
--- 2.6.25-rc8-mm1.orig/drivers/char/tty_io.c	2008-04-07 14:49:56.000000000 -0700
+++ 2.6.25-rc8-mm1/drivers/char/tty_io.c	2008-04-08 09:12:55.000000000 -0700
@@ -2835,8 +2835,8 @@ static int ptmx_open(struct inode *inode
 	filp->private_data = tty;
 	file_move(filp, &tty->tty_files);
 
-	retval = -ENOMEM;
-	if (devpts_pty_new(tty->link))
+	retval = devpts_pty_new(tty->link);
+	if (retval)
 		goto out1;
 
 	check_tty_count(tty, "tty_open");
