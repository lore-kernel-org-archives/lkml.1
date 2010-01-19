Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257Ab0ASLN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab0ASLN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 06:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175Ab0ASLNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 06:13:09 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:40542 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756138Ab0ASLNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 06:13:05 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH 3/4] serial: bfin_5xx: kgdboc should accept gdb break only when it is active
Date: Tue, 19 Jan 2010 06:13:12 -0500
Message-Id: <1263899593-12178-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263899593-12178-1-git-send-email-vapier@gentoo.org>
References: <1263899593-12178-1-git-send-email-vapier@gentoo.org>
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
index b5a9b37..6b87955 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -237,7 +237,8 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 
 #if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
 	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
-	if (kgdb_connected && kgdboc_port_line == uart->port.line)
+	if (kgdb_connected && kgdboc_port_line == uart->port.line
+		&& kgdboc_break_enabled)
 		if (ch == 0x3) {/* Ctrl + C */
 			kgdb_breakpoint();
 			return;
-- 
1.6.6

