Return-Path: <linux-kernel-owner+w=401wt.eu-S1751112AbZK0FFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112AbZK0FFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 00:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZK0FFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 00:05:41 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:38081 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZK0FFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 00:05:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=SDM91hnsdDD90jfwRuogRdbIPFTH6cdBNt8oETAD0qUIjHFVRor/qWxjQAIzZAdCjk
         JiQF6S0j6B1fqkF2xAe3iMXdKXPcrWbEiLI89xO9279aq7KxG4cml0aGTR/ldpRVZjJO
         k98hP7KcsjGFz6IU2v/a9UU+DS+pVKiGCyz2Q=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-mmc@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ian@mnementh.co.uk, lethal@linux-sh.org, philipp.zabel@gmail.com,
       Magnus Damm <magnus.damm@gmail.com>, pierre@ossman.eu
Date: Fri, 27 Nov 2009 14:00:05 +0900
Message-Id: <20091127050005.15251.64306.sendpatchset@rxone.opensource.se>
In-Reply-To: <20091127045956.15251.84958.sendpatchset@rxone.opensource.se>
References: <20091127045956.15251.84958.sendpatchset@rxone.opensource.se>
Subject: [PATCH 01/03] mmc: Let tmio-mmc use dev_name() with request_irq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This change improves the /proc/interrupts output so the
irq number can be mapped to platform device on boards
with multiple tmio_mmc instances.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/mmc/host/tmio_mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 0001/drivers/mmc/host/tmio_mmc.c
+++ work/drivers/mmc/host/tmio_mmc.c	2009-11-26 18:58:08.000000000 +0900
@@ -582,7 +582,7 @@ static int __devinit tmio_mmc_probe(stru
 	disable_mmc_irqs(host, TMIO_MASK_ALL);
 
 	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED |
-		IRQF_TRIGGER_FALLING, "tmio-mmc", host);
+		IRQF_TRIGGER_FALLING, dev_name(&dev->dev), host);
 	if (ret)
 		goto unmap_ctl;
 
