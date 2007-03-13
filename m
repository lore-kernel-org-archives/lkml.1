Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbXCMEth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbXCMEth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 00:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbXCMEth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 00:49:37 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35481 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbXCMEtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 00:49:36 -0400
Date: Mon, 12 Mar 2007 21:49:33 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Eric Biederman <ebiederm@xmission.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Kill unused sesssion and group values in rocket driver
Message-ID: <20070313044933.GA8993@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Operating-System: Linux 2.0.32 on an i486
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [PATCH] Kill unused sesssion and group values in rocket driver

The process_session() and process_group() values are not really
used by the driver.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: containers@lists.osdl.org
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/char/rocket.c     |    3 ---
 drivers/char/rocket_int.h |    2 --
 2 files changed, 5 deletions(-)

Index: lx26-20-mm2c/drivers/char/rocket.c
===================================================================
--- lx26-20-mm2c.orig/drivers/char/rocket.c	2007-02-28 19:23:00.000000000 -0800
+++ lx26-20-mm2c/drivers/char/rocket.c	2007-02-28 19:24:41.000000000 -0800
@@ -1018,9 +1018,6 @@ static int rp_open(struct tty_struct *tt
 	/*
 	 * Info->count is now 1; so it's safe to sleep now.
 	 */
-	info->session = process_session(current);
-	info->pgrp = process_group(current);
-
 	if ((info->flags & ROCKET_INITIALIZED) == 0) {
 		cp = &info->channel;
 		sSetRxTrigger(cp, TRIG_1);
Index: lx26-20-mm2c/drivers/char/rocket_int.h
===================================================================
--- lx26-20-mm2c.orig/drivers/char/rocket_int.h	2007-02-28 19:23:00.000000000 -0800
+++ lx26-20-mm2c/drivers/char/rocket_int.h	2007-02-28 19:24:41.000000000 -0800
@@ -1156,8 +1156,6 @@ struct r_port {
 	int xmit_head;
 	int xmit_tail;
 	int xmit_cnt;
-	int session;
-	int pgrp;
 	int cd_status;
 	int ignore_status_mask;
 	int read_status_mask;
