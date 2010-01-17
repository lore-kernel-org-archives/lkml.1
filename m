Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552Ab0AQPZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab0AQPZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 10:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806Ab0AQPZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 10:25:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53609 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab0AQPZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 10:25:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=srGj8NvQ9JwwZ8daUSL74THfTwgCnfbA4EnCd0pOTQ01V7nUqy3WiGvy/kWFY2R1Dz
         l+sS90bVk4SdCmVXW40C4ONAaLrfllfDN6Za2Xp1E19RDREbm/6SU7+ZY5Xc8Wza29v5
         gBPdiCVjylDpGa14oqQWh0c3Ggj566stulTTg=
Message-ID: <4B532CF5.7080000@gmail.com>
Date: Sun, 17 Jan 2010 16:29:57 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: alan@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] serial: Two branches the same in timbuart_set_mctrl()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regardless of the condition, the branches execute the same code

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Was this maybe intended? please review.

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
