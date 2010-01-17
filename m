Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497Ab0AQS6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0AQS6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169Ab0AQS6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:58:07 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:35695 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab0AQS6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:58:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=B4bCdjBniyc7qrDEvumgu8F0wXWWy/R6NBSoYpiBxlije47ezmpA7YEjHbVXbj7l9m
         Bi3TeMOtgq13VHpYNQPLDNUx7bz8i+Luz6o0oiylMDV6IJ7LACvnjRHPxX/Ht26MpdIj
         T3fxU/7uKlAbCc6M4e8PEugcjK52gVzIzsvtg=
Message-ID: <4B535ED8.2050703@gmail.com>
Date: Sun, 17 Jan 2010 20:02:48 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: richard.rojfors.ext@mocean-labs.com
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial: Two branches the same in timbuart_set_mctrl()
References: <4B532CF5.7080000@gmail.com> <20100117181702.026269e9@lxorguk.ukuu.org.uk>
In-Reply-To: <20100117181702.026269e9@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Richard Röjfors,

It is possible that I found a bug in the Timberdale UART driver that was added
to the linux kernel. The patch below tries to fix this, note the RTS to CTS
change, could you confirm whether the patch below changes your driver
correctly?

Thank you,

Roel Kluin
----------------->8----------------------------8<-------------------------------
Regardless of whether the TIOCM_RTS bit was set in mctrl, the same write
occurred.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/serial/timbuart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/timbuart.c b/drivers/serial/timbuart.c
index 34b31da..c433d40 100644
--- a/drivers/serial/timbuart.c
+++ b/drivers/serial/timbuart.c
@@ -219,7 +219,7 @@ static void timbuart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	if (mctrl & TIOCM_RTS)
 		iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
 	else
-		iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
+		iowrite8(TIMBUART_CTRL_CTS, port->membase + TIMBUART_CTRL);
 }
 
 static void timbuart_mctrl_check(struct uart_port *port, u32 isr, u32 *ier)
