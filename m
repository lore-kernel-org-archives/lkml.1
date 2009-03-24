Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbZCXORj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbZCXORj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759557AbZCXOHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:07:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48953 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755346AbZCXOD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:03:26 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 12/30] blackfin: Fix tty compile error in PIO mode
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:03:47 +0000
Message-ID: <20090324140340.12735.44126.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/bfin_5xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index 6bd9016..1e08e36 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -174,10 +174,10 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
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

