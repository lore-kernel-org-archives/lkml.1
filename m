Return-Path: <linux-kernel-owner+w=401wt.eu-S1763295AbZFRHrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763295AbZFRHrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759160AbZFRHrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:47:00 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:36295 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859AbZFRHq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:46:59 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH v2 1/1] Char: tty, fix tty_port_block_til_ready waiting
Date: Thu, 18 Jun 2009 09:46:13 +0200
Message-Id: <1245311173-1197-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DEFINE_WAIT instead DECLARE_WAITQUEUE, because we use
prepare/finish_wait since commit
3e3b5c087799e536871c8261b05bc28e4783c8da
(tty: use prepare/finish_wait)

Otherwise we would oops in finish_wait.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/tty_port.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 62dadfc..4e862a7 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -193,7 +193,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 {
 	int do_clocal = 0, retval;
 	unsigned long flags;
-	DECLARE_WAITQUEUE(wait, current);
+	DEFINE_WAIT(wait);
 	int cd;
 
 	/* block if port is in the process of being closed */
-- 
1.6.3.2

