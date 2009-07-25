Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbZGYW5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbZGYW5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 18:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZGYW5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 18:57:16 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:50002 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbZGYW5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 18:57:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=aTzMBMd9nas1Q4PBEQ8KqREZaA2jJsfP4THVMvqjfLPy8efJUH6AYxpqLaCADFBO2T
         5NzEPb0PsIu0mk+YD5kdfPg/Ag6e1RwZ4YOLXXSKajqsVgOf9zj3Fh2lF+4jdYrmJrfQ
         m0EBPh31QqTGBVuhvXXs1rMRDVCeK59375GnA=
Message-ID: <4A6B8E65.1080904@gmail.com>
Date: Sun, 26 Jul 2009 00:59:49 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] cyclades: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq is declared with size NR_CARDS (4), but the loop containing this segment
runs up until NR_ISA_ADDRS (16), possibly reading from irq[i] (and trying to
use the result)

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Credits to Parfait

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 2dafc2d..d067705 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4535,7 +4535,7 @@ static int __init cy_detect_isa(void)
 			continue;
 		}
 #ifdef MODULE
-		if (isparam && irq[i])
+		if (isparam && i < NR_CARDS && irq[i])
 			cy_isa_irq = irq[i];
 		else
 #endif
