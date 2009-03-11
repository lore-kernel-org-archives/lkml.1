Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbZCKTof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbZCKTof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZCKTo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:44:26 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:55815 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZCKToZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:44:25 -0400
Message-ID: <49B81493.7050706@linux.vnet.ibm.com>
Date: Wed, 11 Mar 2009 16:44:19 -0300
From: Breno Leitao <leitao@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 2/2] icom: Removing unused variables
References: <49B7D63E.9050006@linux.vnet.ibm.com> <49B7D830.10601@gmail.com>
In-Reply-To: <49B7D830.10601@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing unused variables

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 drivers/serial/icom.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index 60d87db..6b01ca6 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -1098,7 +1098,6 @@ static void icom_set_termios(struct uart_port *port,
 {
 	int baud;
 	unsigned cflag, iflag;
-	int bits;
 	char new_config2;
 	char new_config3 = 0;
 	char tmp_byte;
@@ -1119,34 +1118,27 @@ static void icom_set_termios(struct uart_port *port,
 	switch (cflag & CSIZE) {
 	case CS5:		/* 5 bits/char */
 		new_config2 |= ICOM_ACFG_5BPC;
-		bits = 7;
 		break;
 	case CS6:		/* 6 bits/char */
 		new_config2 |= ICOM_ACFG_6BPC;
-		bits = 8;
 		break;
 	case CS7:		/* 7 bits/char */
 		new_config2 |= ICOM_ACFG_7BPC;
-		bits = 9;
 		break;
 	case CS8:		/* 8 bits/char */
 		new_config2 |= ICOM_ACFG_8BPC;
-		bits = 10;
 		break;
 	default:
-		bits = 10;
 		break;
 	}
 	if (cflag & CSTOPB) {
 		/* 2 stop bits */
 		new_config2 |= ICOM_ACFG_2STOP_BIT;
-		bits++;
 	}
 	if (cflag & PARENB) {
 		/* parity bit enabled */
 		new_config2 |= ICOM_ACFG_PARITY_ENAB;
 		trace(ICOM_PORT, "PARENB", 0);
-		bits++;
 	}
 	if (cflag & PARODD) {
 		/* odd parity */
@@ -1322,7 +1314,6 @@ static struct uart_driver icom_uart_driver = {
 static int __devinit icom_init_ports(struct icom_adapter *icom_adapter)
 {
 	u32 subsystem_id = icom_adapter->subsystem_id;
-	int retval = 0;
 	int i;
 	struct icom_port *icom_port;
 
@@ -1368,7 +1359,7 @@ static int __devinit icom_init_ports(struct icom_adapter *icom_adapter)
 		}
 	}
 
-	return retval;
+	return 0;
 }
 
 static void icom_port_active(struct icom_port *icom_port, struct icom_adapter *icom_adapter, int port_num)
@@ -1391,7 +1382,6 @@ static int __devinit icom_load_ports(struct icom_adapter *icom_adapter)
 {
 	struct icom_port *icom_port;
 	int port_num;
-	int retval;
 
 	for (port_num = 0; port_num < icom_adapter->numb_ports; port_num++) {
 
@@ -1405,7 +1395,7 @@ static int __devinit icom_load_ports(struct icom_adapter *icom_adapter)
 			icom_port->adapter = icom_adapter;
 
 			/* get port memory */
-			if ((retval = get_port_memory(icom_port)) != 0) {
+			if (get_port_memory(icom_port) != 0) {
 				dev_err(&icom_port->adapter->pci_dev->dev,
 					"Memory allocation for port FAILED\n");
 			}
-- 
1.6.0.2

