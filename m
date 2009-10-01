Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbZJAO3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbZJAO3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932661AbZJAO3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:29:23 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:34290 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932542AbZJAO3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:29:23 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH] net/ppp: fix comments - ppp_{sync,asynctty}_receive() may sleep
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       Jarek Poplawski <jarkao2@gmail.com>, linux-kernel@vger.kernel.org
Message-Id: <20091001142844.C50E511186D@xenon.ts.pxnet.com>
Date: Thu,  1 Oct 2009 16:28:44 +0200 (CEST)
X-Spam-Score: -2.212 () BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The receive_buf methods of the N_PPP and N_SYNC_PPP line disciplines,
ppp_asynctty_receive() and ppp_sync_receive(), call tty_unthrottle()
which may sleep. Fix the comments claiming otherwise.

Impact: documentation
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/net/ppp_async.c   |    5 +----
 drivers/net/ppp_synctty.c |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ppp_async.c b/drivers/net/ppp_async.c
index 6de8399..30b1b33 100644
--- a/drivers/net/ppp_async.c
+++ b/drivers/net/ppp_async.c
@@ -337,10 +337,7 @@ ppp_asynctty_poll(struct tty_struct *tty, struct file *file, poll_table *wait)
 	return 0;
 }
 
-/*
- * This can now be called from hard interrupt level as well
- * as soft interrupt level or mainline.
- */
+/* May sleep, don't call from interrupt level or with interrupts disabled */
 static void
 ppp_asynctty_receive(struct tty_struct *tty, const unsigned char *buf,
 		  char *cflags, int count)
diff --git a/drivers/net/ppp_synctty.c b/drivers/net/ppp_synctty.c
index d2fa2db..c908b08 100644
--- a/drivers/net/ppp_synctty.c
+++ b/drivers/net/ppp_synctty.c
@@ -378,10 +378,7 @@ ppp_sync_poll(struct tty_struct *tty, struct file *file, poll_table *wait)
 	return 0;
 }
 
-/*
- * This can now be called from hard interrupt level as well
- * as soft interrupt level or mainline.
- */
+/* May sleep, don't call from interrupt level or with interrupts disabled */
 static void
 ppp_sync_receive(struct tty_struct *tty, const unsigned char *buf,
 		  char *cflags, int count)
-- 
1.6.2.1.214.ge986c

