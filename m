Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZKWDfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZKWDfC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 22:35:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbZKWDfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 22:35:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60958 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229AbZKWDfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 22:35:00 -0500
Date: Mon, 23 Nov 2009 14:35:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Paul Fertser <fercerpav@gmail.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: linux-next: mfd tree build failure
Message-Id: <20091123143503.3cdf8dee.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/power/pcf50633-charger.c: In function 'pcf50633_mbc_get_usb_online_status':
drivers/power/pcf50633-charger.c:147: error: 'struct pcf50633' has no member named 'mbc_pdev'

Caused by commit 4c2e3bacc050f0ebf884954bb007616c162564cd ("mfd: pcf50633
- fix error handling during probe") from the mfd tree interacting with
commit c329795052aa339850a45fab649ab97a36905136 ("pcf50633: Query charger
status directly") from the battery tree.

I have applied the following merge fixup patch and can carry it as
necessary.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 23 Nov 2009 14:31:43 +1100
Subject: [PATCH] mfd: fix pcf50633-charger.c for fallout from merge

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/power/pcf50633-charger.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index d4a3e77..4e535bb 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -144,7 +144,8 @@ EXPORT_SYMBOL_GPL(pcf50633_mbc_get_status);
 
 int pcf50633_mbc_get_usb_online_status(struct pcf50633 *pcf)
 {
-	struct pcf50633_mbc *mbc  = platform_get_drvdata(pcf->mbc_pdev);
+	struct pcf50633_mbc *mbc =
+		platform_get_drvdata(pcf->pdevs[PCF50633_PDEV_ADC_IDX]);
 
 	if (!mbc)
 		return 0;
-- 
1.6.5.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
