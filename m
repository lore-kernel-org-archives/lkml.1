Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812Ab0A2Jvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812Ab0A2Jvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467Ab0A2Jvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:51:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59032 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab0A2Jve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:51:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=v8CmOiFtUZXJfaAn+EeRLCF3Xp40xTFOHjYf9rQe6HToX/xIrh1/2TcEveJoQKp/Vd
         E4tntycnaeSrTPkqL5L+km9GTqdKGNNPMzBcMGlb5vnfzCppZrX5Cg1Qch28tAgx/yaR
         1UlhsA90+J0wBWyv/pT7d1Kb7zwlxV8brQuW0=
Message-ID: <4B62B100.9090308@gmail.com>
Date: Fri, 29 Jan 2010 10:57:20 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Karsten Keil <isdn@linux-pingi.de>, isdn4linux@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] mISDN: positive error return should be negative in mode_hfcmulti()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error return should be negative. Its only caller that acts upon its return,
handle_bmsg(), transmits the positive error but can also return negative errors.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 1a1420d..ad36df9 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -2846,7 +2846,7 @@ mode_hfcmulti(struct hfc_multi *hc, int ch, int protocol, int slot_tx,
 	int conf;
 
 	if (ch < 0 || ch > 31)
-		return EINVAL;
+		return -EINVAL;
 	oslot_tx = hc->chan[ch].slot_tx;
 	oslot_rx = hc->chan[ch].slot_rx;
 	conf = hc->chan[ch].conf;
