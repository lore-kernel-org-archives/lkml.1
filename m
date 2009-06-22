Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZFVQjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZFVQjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757146AbZFVQiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:38:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41756 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756429AbZFVQiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:38:55 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/15] serial: bfin_5xx: add missing spin_lock init
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 18:37:24 +0100
Message-ID: <20090622173115.25341.3717.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
References: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>

The Blackfin serial driver never initialized the spin_lock that is part of
the serial core structure, but we never noticed because spin_lock's are
rarely enabled on UP systems.  Yeah lockdep and friends.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
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

