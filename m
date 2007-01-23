Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbXAWScH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbXAWScH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 13:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbXAWScH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 13:32:07 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:36799 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961AbXAWScG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 13:32:06 -0500
Message-ID: <45B654A2.1020108@fr.ibm.com>
Date: Tue, 23 Jan 2007 19:32:02 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] mxser: remove useless fields
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

the session and pgrp fields in mxser_struct are unused.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>

---
 drivers/char/mxser.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: 2.6.20-rc4-mm1/drivers/char/mxser.c
===================================================================
--- 2.6.20-rc4-mm1.orig/drivers/char/mxser.c
+++ 2.6.20-rc4-mm1/drivers/char/mxser.c
@@ -321,8 +321,6 @@ struct mxser_struct {
 	unsigned long event;
 	int count;		/* # of fd on device */
 	int blocked_open;	/* # of blocked opens */
-	long session;		/* Session of opening process */
-	long pgrp;		/* pgrp of opening process */
 	unsigned char *xmit_buf;
 	int xmit_head;
 	int xmit_tail;
@@ -1001,15 +999,12 @@ static int mxser_open(struct tty_struct 
 		mxser_change_speed(info, NULL);
 	}
 
-	info->session = process_session(current);
-	info->pgrp = process_group(current);
-
 	/*
 	status = mxser_get_msr(info->base, 0, info->port);
 	mxser_check_modem_status(info, status);
 	*/
 
-/* unmark here for very high baud rate (ex. 921600 bps) used */
+	/* unmark here for very high baud rate (ex. 921600 bps) used */
 	tty->low_latency = 1;
 	return 0;
 }
