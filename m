Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZG2TXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZG2TXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 15:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZG2TXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 15:23:21 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:38884 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZG2TXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 15:23:20 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2009 15:23:20 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Bg+V/RzjAwaP2V6/MWrkjV1HTN/i6J3iudFYRDKy0Ba/jQERV7CyI2Ll1ZD9c4WivE
         AJehu4lccRnIF9vzPlqeYqZF+BYD6lhxncrRhB6Vw85sMn/+YhN1M22VAPuMZXicFjXj
         G/dknWyq7R4exP3S7kwLx6tbp1C4GDguduRn8=
Message-ID: <4A70A10D.6030503@gmail.com>
Date: Wed, 29 Jul 2009 21:20:45 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] newport_con: Read outside array bounds
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It read linetable[] before checking bounds of index, and ARRAY_SIZE
is required because linetable[] are unsigned shorts.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This one wasn't spotted by parfait.

diff --git a/drivers/video/console/newport_con.c b/drivers/video/console/newport_con.c
index d31b203..3772433 100644
--- a/drivers/video/console/newport_con.c
+++ b/drivers/video/console/newport_con.c
@@ -216,7 +216,7 @@ static void newport_get_screensize(void)
 	}
 
 	newport_xsize = newport_ysize = 0;
-	for (i = 0; linetable[i + 1] && (i < sizeof(linetable)); i += 2) {
+	for (i = 0; i < ARRAY_SIZE(linetable) - 1 && linetable[i + 1]; i += 2) {
 		cols = 0;
 		newport_vc2_set(npregs, VC2_IREG_RADDR, linetable[i]);
 		npregs->set.dcbmode = (NPORT_DMODE_AVC2 | VC2_REGADDR_RAM |
