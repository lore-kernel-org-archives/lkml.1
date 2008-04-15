Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbYDOA4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbYDOA4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 20:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbYDOAzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 20:55:50 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:31600 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212AbYDOAzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 20:55:50 -0400
Message-ID: <4803FD15.6030006@ct.jp.nec.com>
Date: Mon, 14 Apr 2008 17:55:49 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] tty: fix routine name in ptmx_open()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

At ptmx_open(), the 2nd parameter for check_tty_count() should
be "ptmx_open".

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 drivers/char/tty_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 613ec81..546217d 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2774,7 +2774,7 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 	if (devpts_pty_new(tty->link))
 		goto out1;
 
-	check_tty_count(tty, "tty_open");
+	check_tty_count(tty, "ptmx_open");
 	retval = ptm_driver->open(tty, filp);
 	if (!retval) {
 		tty_audit_opening();
-- 
1.5.4.1

