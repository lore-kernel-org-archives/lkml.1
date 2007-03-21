Return-Path: <linux-kernel-owner+w=401wt.eu-S1751783AbXCUKI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751783AbXCUKI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 06:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbXCUKH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 06:07:59 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:11802 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbXCUKH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 06:07:28 -0400
X-IronPort-AV: i="4.14,308,1170651600"; 
   d="scan'208"; a="25051816:sNHT21922327"
Subject: [PATCH -mm 2/4] Blackfin: serial update driver for Blackfin
	architecture
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
       rmk+lkml@arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 21 Mar 2007 18:07:23 +0800
Message-Id: <1174471644.5648.52.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Since we support break handling, we shouldn't use these flags.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---

 drivers/serial/bfin_5xx.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: linux-2.6/drivers/serial/bfin_5xx.c
===================================================================
--- linux-2.6.orig/drivers/serial/bfin_5xx.c
+++ linux-2.6/drivers/serial/bfin_5xx.c
@@ -615,11 +615,7 @@
        }

        /* These controls are not implemented for this port */
-       termios->c_iflag |= INPCK | BRKINT | PARMRK;
-       termios->c_iflag &= ~(IGNPAR | IGNBRK);
-
-       /* These controls are not implemented for this port */
-       termios->c_iflag |= INPCK | BRKINT | PARMRK;
+       termios->c_iflag |= INPCK;
        termios->c_iflag &= ~(IGNPAR | IGNBRK);

        baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
_

Thanks
-Bryan Wu
