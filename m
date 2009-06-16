Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbZFPTNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbZFPTNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZFPTNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:13:05 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:60077 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZFPTNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:13:04 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] Char: tty, fix tty_port_block_til_ready waiting
Date: Tue, 16 Jun 2009 21:13:00 +0200
Message-Id: <1245179580-25402-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DEFINE_WAIT instead of DECLARE_WAITQUEUE, because we use
prepare/finish_wait since commit
3e3b5c087799e536871c8261b05bc28e4783c8da
(tty: use prepare/finish_wait)

Otherwise we would oops in finish_wait.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/tty_port.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 62dadfc..a8ed648 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -193,7 +193,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 {
 	int do_clocal = 0, retval;
 	unsigned long flags;
-	DECLARE_WAITQUEUE(wait, current);
+	DEFINE_WAIT(wait, current);
 	int cd;
 
 	/* block if port is in the process of being closed */
-- 
1.6.3.2

