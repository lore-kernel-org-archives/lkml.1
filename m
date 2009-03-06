Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbZCFGnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbZCFGnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 01:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZCFGlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 01:41:00 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:33492 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbZCFGk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 01:40:56 -0500
X-IronPort-AV: E=Sophos;i="4.38,312,1233550800"; 
   d="scan'208";a="83883655"
From: Bryan Wu <cooloney@kernel.org>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 10/18] Blackfin Serial Driver: fix compile error in PIO mode
Date: Fri,  6 Mar 2009 14:42:52 +0800
Message-Id: <1236321780-28718-11-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

drivers/serial/bfin_5xx.c: In function bfin_serial_rx_chars:
drivers/serial/bfin_5xx.c:178: error: struct uart_info has no
member
named tty
make[3]: *** [drivers/serial/bfin_5xx.o] Error 1
make[2]: *** [drivers/serial] Error 2
make[1]: *** [drivers] Error 2
make[1]: *** Waiting for unfinished jobs....
make[1]: Leaving directory `/root/projects/uClinux-dist/linux-2.6.x'
make: *** [linux] Error 1

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/serial/bfin_5xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 130e321..5193d62 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -172,10 +172,10 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
 			return;
 		}
 
-	if (!uart->port.info || !uart->port.info->tty)
+	if (!uart->port.info || !uart->port.info->port.tty)
 		return;
 #endif
-	tty = uart->port.info->tty;
+	tty = uart->port.info->port.tty;
 
 	if (ANOMALY_05000363) {
 		/* The BF533 (and BF561) family of processors have a nice anomaly
-- 
1.5.6.3
