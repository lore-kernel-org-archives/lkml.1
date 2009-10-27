Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbZJ0LwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbZJ0LwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 07:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZJ0LwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 07:52:09 -0400
Received: from pptp-il.jungo.com ([194.90.113.98]:43429 "EHLO
	wall-ext.jungo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbZJ0LwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 07:52:08 -0400
Date: Tue, 27 Oct 2009 13:52:05 +0200
From: Shmulik Ladkani <shmulik@jungo.com>
To: linux-serial@vger.kernel.org
Cc: shmulik@jungo.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: copy UART properties of UPF_FIXED_TYPE ports
 provisioned  using early_serial_setup
Message-ID: <20091027135205.74bbf5f7@pixies.home.jungo.com>
In-Reply-To: <dzvMe-7Mg-3@gated-at.bofh.it>
References: <dzvMe-7Mg-3@gated-at.bofh.it>
Organization: Jungo Ltd.
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Oct 2009 12:20:02 +0100 Shmulik Ladkani <shmulik@jungo.com> wrote:
> Augment the UPF_FIXED_TYPE logic, which currently applies to UART ports 
> provisioned using platform_device_register.
> 
> The suggested patch applies same logic into 'serial8250_register_ports', 
> making UART ports provisioned using early_serial_setup inherit their 
> properties from the uart_config entry.
> 
> The patch applies to linux-2.6.32-rc5

Re-submit (previous mailer messed-up whitespace).

Signed-off-by: Shmulik Ladkani <shmulik@jungo.com>
---
diff -upr linux-2.6.32-rc5.clean/drivers/serial/8250.c linux-2.6.32-rc5/drivers/serial/8250.c
--- linux-2.6.32-rc5.clean/drivers/serial/8250.c	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5/drivers/serial/8250.c	2009-10-26 11:36:09.000000000 +0200
@@ -2704,6 +2704,14 @@ serial8250_register_ports(struct uart_dr
 		struct uart_8250_port *up = &serial8250_ports[i];
 
 		up->port.dev = dev;
+
+		if (up->port.flags & UPF_FIXED_TYPE) {
+			up->port.fifosize =
+				uart_config[up->port.type].fifo_size;
+			up->capabilities = uart_config[up->port.type].flags;
+			up->tx_loadsz = uart_config[up->port.type].tx_loadsz;
+		}
+
 		uart_add_one_port(drv, &up->port);
 	}
 }
-- 
Shmulik Ladkani		Jungo Ltd.
