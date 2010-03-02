Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab0CBXhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:37:15 -0500
Received: from kroah.org ([198.145.64.141]:51623 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab0CBXhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:02 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/36] serial: bfin_5xx: kgdboc should accept gdb break only when it is active
Date: Tue,  2 Mar 2010 15:36:29 -0800
Message-Id: <1267573003-782-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

If we always check for gdb breaks even when it isn't active, we get false
positives on normal code and the system panics.

URL: http://blackfin.uclinux.org/gf/tracker/5277

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.0.1

