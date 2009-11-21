Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZKUPDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZKUPDG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbZKUPDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:03:04 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40478 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998AbZKUPDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:03:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=cWgezCKMC7DMGQUSBBOY19Xjsmf0uxweI7CH4mWQSViF89xdPncD4B86msVPIeCx8F
         OHkA/fzuTV6ueFi4m+6hi9sf3cplYDAUkoj8M79sSFxDKiDiPXQMzPVkJdKMyBAq5gVx
         TUyN9GWNjyYJNYOzwNGrOOIXUs7+Tkmt7blJo=
Message-ID: <4B08042E.2090705@gmail.com>
Date: Sat, 21 Nov 2009 16:15:58 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, kernel@pengutronix.de,
       linux-arm-kernel@lists.infradead.org
Subject: [PATCH] imx: bit &/| confusion
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

since UCR1_UARTEN is defined 1, the port was always treated as enabled.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---

diff --git a/drivers/serial/imx.c b/drivers/serial/imx.c
index 18130f1..60d665a 100644
--- a/drivers/serial/imx.c
+++ b/drivers/serial/imx.c
@@ -1088,7 +1088,7 @@ imx_console_get_options(struct imx_port *sport, int *baud,
 			   int *parity, int *bits)
 {
 
-	if ( readl(sport->port.membase + UCR1) | UCR1_UARTEN ) {
+	if (readl(sport->port.membase + UCR1) & UCR1_UARTEN) {
 		/* ok, the port was enabled */
 		unsigned int ucr2, ubir,ubmr, uartclk;
 		unsigned int baud_raw;
