Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbZGAA6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbZGAA6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761423AbZGAAep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:45 -0400
Received: from kroah.org ([198.145.64.141]:60325 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761396AbZGAAeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:25 2009
Message-Id: <20090701002425.687060928@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Frysinger <vapier@gentoo.org>, Alan Cox <alan@linux.intel.com>
Subject: [patch 041/108] serial: bfin_5xx: add missing spin_lock init
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=serial-bfin_5xx-add-missing-spin_lock-init.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Frysinger <vapier@gentoo.org>

commit 9c529a3d76dffae943868ebad07b042d15764712 upstream.

The Blackfin serial driver never initialized the spin_lock that is part of
the serial core structure, but we never noticed because spin_lock's are
rarely enabled on UP systems.  Yeah lockdep and friends.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/bfin_5xx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/serial/bfin_5xx.c
+++ b/drivers/serial/bfin_5xx.c
@@ -1058,6 +1058,7 @@ static void __init bfin_serial_init_port
 	bfin_serial_hw_init();
 
 	for (i = 0; i < nr_active_ports; i++) {
+		spin_lock_init(&bfin_serial_ports[i].port.lock);
 		bfin_serial_ports[i].port.uartclk   = get_sclk();
 		bfin_serial_ports[i].port.fifosize  = BFIN_UART_TX_FIFO_SIZE;
 		bfin_serial_ports[i].port.ops       = &bfin_serial_pops;


