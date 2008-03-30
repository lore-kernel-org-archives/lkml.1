Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbYC3XOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbYC3XOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 19:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756838AbYC3XNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 19:13:07 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54791 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587AbYC3XNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 19:13:06 -0400
Date: Mon, 31 Mar 2008 02:12:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] char/n_hdlc.c: don't use 0 as NULL pointer
Message-ID: <20080330231253.GG28445@cs181133002.pp.htv.fi>
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

