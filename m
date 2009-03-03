Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZCCOKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZCCOKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 09:10:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZCCOKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 09:10:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:11986 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZCCOKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 09:10:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=rIW8YNvZVgK1ro2Bdk3PIs/NP22PThDq5uk4mKZZpZmOlmneRLkd8AGjKpjhfhcM+u
         TzrmucGh792QsdDcbtG8W95v7xAq8DEyqRl1M+mIKPL0lWRuEE/U+Loijhi7ZPFbACgy
         4phSEoakMT3WJf+yxYDzfvvpP3a+ORzOzuEms=
Message-ID: <49AD3A3D.4040303@gmail.com>
Date: Tue, 03 Mar 2009 15:10:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: wim@iguana.be
CC: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] watchdog: fsl_get_sys_freq() failure not noticed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe it is nicer to do a test like:

	if (freq < MAX_FREQ)

but I don't know what MAX_FREQ should be.
------------------------------>8-------------8<---------------------------------
fsl_get_sys_freq() may return -1 when 'soc' isn't found, but in gef_wdt_probe()
'freq' is unsigned, so the test doesn't catch that.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index f0c2b7a..734d980 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -269,7 +269,7 @@ static int __devinit gef_wdt_probe(struct of_device *dev,
 	bus_clk = 133; /* in MHz */
 
 	freq = fsl_get_sys_freq();
-	if (freq > 0)
+	if (freq != -1)
 		bus_clk = freq;
 
 	/* Map devices registers into memory */
