Return-Path: <linux-kernel-owner+w=401wt.eu-S1751893AbZIQVwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbZIQVwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZIQVwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:52:32 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49478 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbZIQVw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:52:28 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 3/4] serial: bfin_5xx: kgdboc should accept gdb break only when it is active
Date: Thu, 17 Sep 2009 17:52:27 -0400
Message-Id: <1253224348-6996-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc1
In-Reply-To: <1253224348-6996-1-git-send-email-vapier@gentoo.org>
References: <1253224348-6996-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

If we always check for gdb breaks even when it isn't active, we get false
positives on normal code and the system panics.

URL: http://blackfin.uclinux.org/gf/tracker/5277
Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_5xx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 663fec1..67fa057 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -233,7 +233,8 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 
 #if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
 	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
-	if (kgdb_connected && kgdboc_port_line == uart->port.line)
+	if (kgdb_connected && kgdboc_port_line == uart->port.line
+		&& kgdboc_break_enabled)
 		if (ch == 0x3) {/* Ctrl + C */
 			kgdb_breakpoint();
 			return;
-- 
1.6.5.rc1

