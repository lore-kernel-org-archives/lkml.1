Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYJUTQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYJUTQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbYJUTPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:15:13 -0400
Received: from mail.windriver.com ([147.11.1.11]:44697 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475AbYJUTPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:15:11 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
       alan@lxorguk.ukuu.org.uk
Subject: [PATCH 2/7] tty: Fix sparse static warning for tty_driver_lookup_tty
Date: Tue, 21 Oct 2008 14:14:48 -0500
Message-Id: <1224616493-23237-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1224616493-23237-2-git-send-email-jason.wessel@windriver.com>
References: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com>
 <1224616493-23237-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 21 Oct 2008 19:14:55.0873 (UTC) FILETIME=[4D785710:01C933B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed sparse warning:
drivers/char/tty_io.c:1216:19: warning: symbol 'tty_driver_lookup_tty' was not declared. Should it be static?

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/char/tty_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 59f4721..6fb2cbf 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1213,7 +1213,7 @@ static void tty_line_name(struct tty_driver *driver, int index, char *p)
  *	be held until the 'fast-open' is also done. Will change once we
  *	have refcounting in the driver and per driver locking
  */
-struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
+static struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
 		struct inode *inode, int idx)
 {
 	struct tty_struct *tty;
-- 
1.6.0.2

