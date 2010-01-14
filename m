Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243Ab0ANQvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab0ANQvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 11:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756835Ab0ANQvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 11:51:39 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:54822 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab0ANQvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 11:51:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=gjyI1gYYzH8ccLcg+UIDFbHqv9hTXT1Kn+x8cBXKGNwSOWzk2OAccrick5cSbGMK3V
         AzS5NSKezCEM/TqGn5HiW5XhAzSDLKhWTBw15TsgJBDIykYj7c384j7Dc1XGVmDgwKh3
         o4GGekLkF9viCz0bzxuxl1Frz3Gp/QFiJLjTY=
Message-ID: <4B4F4C9B.9040202@gmail.com>
Date: Thu, 14 Jan 2010 17:55:55 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sparc: leds_resource.end assigned to itself in clock_board_probe()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These statements appear redundant.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is there any reason to assign this to itself?

diff --git a/arch/sparc/kernel/central.c b/arch/sparc/kernel/central.c
index f3b5466..773caf4 100644
--- a/arch/sparc/kernel/central.c
+++ b/arch/sparc/kernel/central.c
@@ -99,7 +99,6 @@ static int __devinit clock_board_probe(struct of_device *op,
 
 	p->leds_resource.start = (unsigned long)
 		(p->clock_regs + CLOCK_CTRL);
-	p->leds_resource.end = p->leds_resource.end;
 	p->leds_resource.name = "leds";
 
 	p->leds_pdev.name = "sunfire-clockboard-leds";
@@ -194,7 +193,6 @@ static int __devinit fhc_probe(struct of_device *op,
 	if (!p->central) {
 		p->leds_resource.start = (unsigned long)
 			(p->pregs + FHC_PREGS_CTRL);
-		p->leds_resource.end = p->leds_resource.end;
 		p->leds_resource.name = "leds";
 
 		p->leds_pdev.name = "sunfire-fhc-leds";
