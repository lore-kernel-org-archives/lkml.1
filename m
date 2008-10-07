Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbYJGX5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbYJGX5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYJGX50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:57:26 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:35640 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbYJGX5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:57:25 -0400
Message-ID: <48EBF75F.2000404@caviumnetworks.com>
Date: Tue, 07 Oct 2008 16:57:19 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
CC: "Paoletti, Tomaso" <Tomaso.Paoletti@caviumnetworks.com>
Subject: [PATCH 3/4] serial: Allow port type to specify bugs that are not
 probed for.
References: <48EBF426.9080500@caviumnetworks.com>
In-Reply-To: <48EBF426.9080500@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2008 23:57:19.0472 (UTC) FILETIME=[6EDBDF00:01C928D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow port type to specify bugs that are not probed for.

Add a bugs field to the serial8250_config and propagate it to the
port's bugs field when the port is registered and configured.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/serial/8250.c |    2 ++
 drivers/serial/8250.h |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index c575b61..19a8373 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1197,6 +1197,7 @@ static void autoconfig(struct uart_8250_port *up, unsigned int probeflags)
 	up->port.fifosize = uart_config[up->port.type].fifo_size;
 	up->capabilities = uart_config[up->port.type].flags;
 	up->tx_loadsz = uart_config[up->port.type].tx_loadsz;
+	up->bugs |= uart_config[up->port.type].bugs;
 
 	if (up->port.type == PORT_UNKNOWN)
 		goto out;
@@ -2981,6 +2982,7 @@ int serial8250_register_port(struct uart_port *port)
 			uart->port.fifosize = uart_config[port->type].fifo_size;
 			uart->capabilities = uart_config[port->type].flags;
 			uart->tx_loadsz = uart_config[port->type].tx_loadsz;
+			uart->bugs = uart_config[port->type].bugs;
 		}
 
 		set_io_fns_from_upio(&uart->port);
diff --git a/drivers/serial/8250.h b/drivers/serial/8250.h
index 5202603..c9b3002 100644
--- a/drivers/serial/8250.h
+++ b/drivers/serial/8250.h
@@ -34,6 +34,7 @@ struct serial8250_config {
 	const char	*name;
 	unsigned short	fifo_size;
 	unsigned short	tx_loadsz;
+	unsigned short	bugs;
 	unsigned char	fcr;
 	unsigned int	flags;
 };
