Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbYJFR1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbYJFR1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 13:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbYJFR05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 13:26:57 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:25458 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753858AbYJFR04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:26:56 -0400
Date: Mon, 6 Oct 2008 21:26:54 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Li Yang <leoli@freescale.com>, Wang Jian <lark@linux.net.cn>,
       "Steven A. Falco" <sfalco@harris.com>, linuxppc-dev@ozlabs.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pata_of_platform: fix no irq handling
Message-ID: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When no irq specified the pata_of_platform fills the irq_res with -1,
which is wrong to do for two reasons:

1. By definition, 'no irq' should be IRQ 0, not some negative integer;
2. pata_platform checks for irq_res.start > 0, but since irq_res.start
   is unsigned type, the check will be true for `-1'.

Reported-by: Steven A. Falco <sfalco@harris.com>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

Resending again...

 drivers/ata/pata_of_platform.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
index 408da30..1f18ad9 100644
--- a/drivers/ata/pata_of_platform.c
+++ b/drivers/ata/pata_of_platform.c
@@ -52,7 +52,7 @@ static int __devinit pata_of_platform_probe(struct of_device *ofdev,
 
 	ret = of_irq_to_resource(dn, 0, &irq_res);
 	if (ret == NO_IRQ)
-		irq_res.start = irq_res.end = -1;
+		irq_res.start = irq_res.end = 0;
 	else
 		irq_res.flags = 0;
 
-- 
1.5.6.3

