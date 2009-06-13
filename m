Return-Path: <linux-kernel-owner+w=401wt.eu-S1763435AbZFMAsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763435AbZFMAsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZFMAsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:48:24 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49020 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbZFMAsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:48:23 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 1/2] serial: bfin_5xx: add missing spin_lock init
Date: Fri, 12 Jun 2009 20:48:12 -0400
Message-Id: <1244854093-2156-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Blackfin serial driver never initialized the spin_lock that is part of
the serial core structure, but we never noticed because spin_lock's are
rarely enabled on UP systems.  Yeah lockdep and friends.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/serial/bfin_5xx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
index e2f6b1b..d7fcca1 100644
--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1110,6 +1110,7 @@ static void __init bfin_serial_init_ports(void)
 	bfin_serial_hw_init();
 
 	for (i = 0; i < nr_active_ports; i++) {
+		spin_lock_init(&bfin_serial_ports[i].port.lock);
 		bfin_serial_ports[i].port.uartclk   = get_sclk();
 		bfin_serial_ports[i].port.fifosize  = BFIN_UART_TX_FIFO_SIZE;
 		bfin_serial_ports[i].port.ops       = &bfin_serial_pops;
-- 
1.6.3.1

