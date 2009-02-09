Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZBIWMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZBIWMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbZBIWMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:12:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:52308 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbZBIWME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:12:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Yt4NJkFSgabRYWw2Jz8/BpPnuTAbgfXIuJ3l/O/uHnI2MPW8h/sG15wf8TcKOnMEpv
         FcYUtc4LbZy1ncm+hlmQg/LDWAjL5QtbCxCkDgXhq2aqOqniI29nvFaFdnFCssJVAA3A
         8H02wrcX9v/Oj3NGXEOFj47geOCmArP6P0wNQ=
Message-ID: <4990AA32.1010004@gmail.com>
Date: Mon, 09 Feb 2009 23:12:02 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] cassini: i reaches 0, not -1.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With while (i-- > 0) { ... } i reaches 0, not -1.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index bbbc3bb..2de2cdf 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -3568,7 +3568,7 @@ static inline void cas_start_dma(struct cas *cp)
 			break;
 		udelay(10);
 	}
-	if (i < 0) txfailed = 1;
+	if (i <= 0) txfailed = 1;
 	i = STOP_TRIES;
 	while (i-- > 0) {
 		val = readl(cp->regs + REG_MAC_RX_CFG);

