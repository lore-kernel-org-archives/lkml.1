Return-Path: <linux-kernel-owner+w=401wt.eu-S964933AbXAWOmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964933AbXAWOmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965085AbXAWOmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:42:20 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:33868 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964933AbXAWOmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:42:19 -0500
Message-id: <444432691808225221@wsc.cz>
Subject: [PATCH 1/3] Char: mxser_new, do not null driver_data
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <osv@javad.com>
Date: Tue, 23 Jan 2007 15:42:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mxser_new, do not null driver_data

driver_data are initialzed to NULL from tty layer, no need to do it in the
driver. In this case it cases oops, since driver_data may be NULL for a
short while for another closing process.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <osv@javad.com>

---
commit f49b6914c3113f930a31ff7b8f811744f2d8f339
tree d4f8355eb12a89f779dc4b85e7a908b9e80e88d3
parent 2826e3a35f34046890c84a77bc2784a184f9bf6a
author Jiri Slaby <jirislaby@gmail.com> Sat, 20 Jan 2007 17:00:12 +0059
committer Jiri Slaby <jirislaby@gmail.com> Sat, 20 Jan 2007 17:00:12 +0059

 drivers/char/mxser_new.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 4c80549..1c8e00c 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -927,9 +927,6 @@ static int mxser_open(struct tty_struct *tty, struct file *filp)
 	struct mxser_port *info;
 	int retval, line;
 
-	/* initialize driver_data in case something fails */
-	tty->driver_data = NULL;
-
 	line = tty->index;
 	if (line == MXSER_PORTS)
 		return 0;
