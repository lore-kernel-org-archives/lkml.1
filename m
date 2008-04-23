Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbYDWJyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbYDWJyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbYDWJvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:51:22 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36855 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282AbYDWJvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:51:20 -0400
Date: Wed, 23 Apr 2008 12:50:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] char/n_hdlc.c: don't use 0 as NULL pointer
Message-ID: <20080423095041.GP28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use 0 as NULL pointer.

Spotted by sparse.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 14 Apr 2008
- 31 Mar 2008

39d28b33b48bbec91bfbd0e761c2f1e3e1d08b88 diff --git a/drivers/char/n_hdlc.c b/drivers/char/n_hdlc.c
index 82bcfb9..9e6145a 100644
--- a/drivers/char/n_hdlc.c
+++ b/drivers/char/n_hdlc.c
@@ -501,7 +501,7 @@ static void n_hdlc_tty_receive(struct tty_struct *tty, const __u8 *data,
 			__FILE__,__LINE__, count);
 		
 	/* This can happen if stuff comes in on the backup tty */
-	if (n_hdlc == 0 || tty != n_hdlc->tty)
+	if (n_hdlc == NULL || tty != n_hdlc->tty)
 		return;
 		
 	/* verify line is using HDLC discipline */


