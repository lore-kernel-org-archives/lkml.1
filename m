Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbXEOUuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbXEOUuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 16:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXEOUui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 16:50:38 -0400
Received: from nwk-ea-fw-1.sun.com ([192.18.42.249]:25171 "EHLO
	nwk-ea-fw-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbXEOUuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 16:50:37 -0400
Date: Tue, 15 May 2007 13:48:14 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] serial: set DTR in uart for kernel serial console
In-reply-to: <4648B2CC.2020403@sun.com>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       bjorn.helgaas@hp.com, rmk@arm.linux.org.uk
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai.Lu@Sun.COM
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200705151348.15355.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
 <20070514181007.GA29682@flint.arm.linux.org.uk> <4648B2CC.2020403@sun.com>
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hope format is OK. Sending with KMail Message/Insert File

YH

[PATCH] serial: set DTR in uart for kernel serial console

Some UARTs on other side need host uart DTR is set, otherwise will not 
receive char from the host that kernel is runing during kernel boot stage.

BTW:
earlyprintk and early_uart are hard coded to set DTR/RTS.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Andi Kleen <ak@suse.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com> 

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 48e259a..a925547 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2397,6 +2397,11 @@ static void __init serial8250_isa_init_ports(void)
 		up->mcr_force = ALPHA_KLUDGE_MCR;
 
 		up->port.ops = &serial8250_pops;
+
+		/* some uarts on other side don't support no flow control. So we set
+		 * DTR in host uart to make them happy  --- YHLU
+		 */
+		up->port.mctrl |= TIOCM_DTR; 
 	}
 
 	for (i = 0, up = serial8250_ports;
