Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbXJVTEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbXJVTEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbXJVTEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:04:45 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:33794 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbXJVTEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:04:44 -0400
Message-id: <1238327807808324409@pripojeni.net>
Subject: [PATCH 1/1] Char: cyclades, fix potential NULL dereference
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Adrian Bunk <bunk@kernel.org>
Date: Mon, 22 Oct 2007 15:04:44 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, fix potential NULL dereference

to ztxdone is jumped even if tty is NULL and tty_wakeup placed after this
label doesn't expect NULLed parameter, so this will cause an oops in some
situations (why they scheduled a wakeup there before remove bottom half
processing patch?). wakeup only in the case when we have non-null tty
struct.
Spotted by Adrian Bunk.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>

---
commit d5e700a2247a9dc66cda09e6d89d1dc284bda40b
tree e0ba44e65a2026e4cba1e158580eaf492a1bfa35
parent bd9d07361314f393c7686466687c0a7aa8e88109
author Jiri Slaby <jirislaby@gmail.com> Mon, 22 Oct 2007 20:47:01 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 22 Oct 2007 20:47:01 +0200

 drivers/char/cyclades.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index d15234c..710c056 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1604,8 +1604,8 @@ static void cyz_handle_tx(struct cyclades_port *info,
 			info->icount.tx++;
 		}
 #endif
-ztxdone:
 		tty_wakeup(tty);
+ztxdone:
 		/* Update tx_put */
 		cy_writel(&buf_ctrl->tx_put, tx_put);
 	}
