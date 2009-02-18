Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbZBRNxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbZBRNxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 08:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZBRNwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 08:52:53 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57438 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZBRNwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 08:52:53 -0500
Date: Wed, 18 Feb 2009 15:52:51 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Dan Carpenter <error27@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sx.c: fix dbl statement if - add missing braces
Message-ID: <Pine.LNX.4.64.0902181547110.31742@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-183142574-1234965171=:31742"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-183142574-1234965171=:31742
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


Caused by 736d54533aed (sx.c: fix missed unlock_kernel()
on error path in sx_fw_ioctl()). You guys keep breaking
things this way in every single kernel release in at least
couple of places... :-(

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Cc: Dan Carpenter <error27@gmail.com>
---
 drivers/char/sx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index f146e90..d7c4165 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -1746,9 +1746,10 @@ static long sx_fw_ioctl(struct file *filp, unsigned int cmd,
 		sx_dprintk(SX_DEBUG_FIRMWARE, "returning type= %ld\n", rc);
 		break;
 	case SXIO_DO_RAMTEST:
-		if (sx_initialized)	/* Already initialized: better not ramtest the board.  */
+		if (sx_initialized) {	/* Already initialized: better not ramtest the board.  */
 			rc = -EPERM;
 			break;
+		}
 		if (IS_SX_BOARD(board)) {
 			rc = do_memtest(board, 0, 0x7000);
 			if (!rc)
-- 
1.5.2.2

---696208474-183142574-1234965171=:31742--
