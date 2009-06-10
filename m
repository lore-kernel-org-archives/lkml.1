Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbZFKR3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbZFKR3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 13:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZFKR2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 13:28:52 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:48061 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbZFKR2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 13:28:51 -0400
Message-Id: <395df11f5fa7fe852be28ccec8aaa15634386ad1.1244739994.git.keil@b1-systems.de>
In-Reply-To: <cover.1244739994.git.keil@b1-systems.de>
References: <cover.1244739994.git.keil@b1-systems.de>
Date: Wed, 10 Jun 2009 12:52:44 -0700
Subject: [PATCH 4/6] drivers/isdn/i4l/isdn_tty.c: fix check for array overindexing
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

The check for overindexing of dev->mdm.info[] has an off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/i4l/isdn_tty.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 1a2222c..b4d4522 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1592,7 +1592,7 @@ isdn_tty_open(struct tty_struct *tty, struct file *filp)
 	int retval, line;
 
 	line = tty->index;
-	if (line < 0 || line > ISDN_MAX_CHANNELS)
+	if (line < 0 || line >= ISDN_MAX_CHANNELS)
 		return -ENODEV;
 	info = &dev->mdm.info[line];
 	if (isdn_tty_paranoia_check(info, tty->name, "isdn_tty_open"))
-- 
1.6.0.2

