Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbZKNHUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbZKNHUh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 02:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZKNHUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 02:20:36 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38397 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbZKNHUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 02:20:25 -0500
Date: Sat, 14 Nov 2009 18:20:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
       Jochen Friedrich <jochen@scram.de>
Subject: [PATCH] m68k: don't export static inline functions
Message-Id: <20091114182028.16b36c84.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These now cause errors due to changes present in linux-next:

(__ksymtab_sorted+0x1258): undefined reference to `dio_dev_driver'
(__ksymtab_sorted+0x4d48): undefined reference to `zorro_dev_driver'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/dio/dio-driver.c     |    1 -
 drivers/zorro/zorro-driver.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

Mind you, neither of these functions is used anywhere in the kernel
anyway.

diff --git a/drivers/dio/dio-driver.c b/drivers/dio/dio-driver.c
index 9c0c9af..a7b174e 100644
--- a/drivers/dio/dio-driver.c
+++ b/drivers/dio/dio-driver.c
@@ -140,5 +140,4 @@ postcore_initcall(dio_driver_init);
 EXPORT_SYMBOL(dio_match_device);
 EXPORT_SYMBOL(dio_register_driver);
 EXPORT_SYMBOL(dio_unregister_driver);
-EXPORT_SYMBOL(dio_dev_driver);
 EXPORT_SYMBOL(dio_bus_type);
diff --git a/drivers/zorro/zorro-driver.c b/drivers/zorro/zorro-driver.c
index e6c4390..53180a3 100644
--- a/drivers/zorro/zorro-driver.c
+++ b/drivers/zorro/zorro-driver.c
@@ -156,5 +156,4 @@ postcore_initcall(zorro_driver_init);
 EXPORT_SYMBOL(zorro_match_device);
 EXPORT_SYMBOL(zorro_register_driver);
 EXPORT_SYMBOL(zorro_unregister_driver);
-EXPORT_SYMBOL(zorro_dev_driver);
 EXPORT_SYMBOL(zorro_bus_type);
-- 
1.6.5.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
