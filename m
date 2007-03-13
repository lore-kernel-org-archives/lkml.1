Return-Path: <linux-kernel-owner+w=401wt.eu-S1751087AbXCMW3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087AbXCMW3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 18:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbXCMW3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 18:29:33 -0400
Received: from csclub1.cs.uwaterloo.ca ([129.97.7.226]:56243 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751087AbXCMW3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 18:29:33 -0400
Date: Tue, 13 Mar 2007 18:29:32 -0400
To: linux-kernel@vger.kernel.org
Subject: Small fixes for jsm driver
Message-ID: <20070313222932.GD22466@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The jsm driver fails when you try to use the TIOCSSERIAL ioctl.  The
reason is that the driver never sets uart_port.uartclk, causing the data
received using TIOCGSERIAL to not match the internal state of the driver.
This patch fixes this problem by settings the uartclk to the value used
by the serial_core (16 times the baud base).

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

--- a/drivers/serial/jsm/jsm_tty.c	2007-03-13 15:53:39.000000000 -0400
+++ b/drivers/serial/jsm/jsm_tty.c	2007-03-13 15:55:15.000000000 -0400
@@ -471,6 +471,7 @@
 			continue;
 
 		brd->channels[i]->uart_port.irq = brd->irq;
+		brd->channels[i]->uart_port.uartclk = 14745600;
 		brd->channels[i]->uart_port.type = PORT_JSM;
 		brd->channels[i]->uart_port.iotype = UPIO_MEM;
 		brd->channels[i]->uart_port.membase = brd->re_map_membase;
