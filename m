Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbZISViM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbZISViM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZISViJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:38:09 -0400
Received: from kroah.org ([198.145.64.141]:50903 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZISViG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:38:06 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Roel Kluin <roel.kluin@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/79] tty: icom: bit and/or confusion?
Date: Sat, 19 Sep 2009 14:36:12 -0700
Message-Id: <1253396244-7885-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

Previously, if any bit other than CMD_SND_BREAK was set, CMD_SND_BREAK
was not unset.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/icom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index cd1b6a4..060f4e3 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -617,7 +617,7 @@ static void shutdown(struct icom_port *icom_port)
 	 * disable break condition
 	 */
 	cmdReg = readb(&icom_port->dram->CmdReg);
-	if ((cmdReg | CMD_SND_BREAK) == CMD_SND_BREAK) {
+	if (cmdReg & CMD_SND_BREAK) {
 		writeb(cmdReg & ~CMD_SND_BREAK, &icom_port->dram->CmdReg);
 	}
 }
-- 
1.6.4.2

