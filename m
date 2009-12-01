Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbZLAHzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbZLAHzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZLAHy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:54:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561AbZLAHy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:54:58 -0500
Date: Tue, 1 Dec 2009 02:54:44 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, akpm@linux-foundation.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Joe Peterson <joe@skyrush.com>,
       Amerigo Wang <amwang@redhat.com>
Message-Id: <20091201075744.4456.48125.sendpatchset@localhost.localdomain>
Subject: [Patch] tty: move a definition out of switch block
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's not good to leave a definition between 'switch'
and its first label. Move it out of the switch block.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Joe Peterson <joe@skyrush.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 2e50f4d..233aa3d 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -502,6 +502,7 @@ static void process_echoes(struct tty_struct *tty)
 			unsigned char op;
 			unsigned char *opp;
 			int no_space_left = 0;
+			unsigned int num_chars, num_bs;
 
 			/*
 			 * If the buffer byte is the start of a multi-byte
@@ -514,8 +515,6 @@ static void process_echoes(struct tty_struct *tty)
 			op = *opp;
 
 			switch (op) {
-				unsigned int num_chars, num_bs;
-
 			case ECHO_OP_ERASE_TAB:
 				if (++opp == buf_end)
 					opp -= N_TTY_BUF_SIZE;
