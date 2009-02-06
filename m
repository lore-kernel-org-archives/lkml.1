Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbZBFHMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbZBFHMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZBFHLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:19 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:13578 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZBFHLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:17 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422007"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 02/20] Blackfin SPI Driver: Fix erroneous SPI Clock divisor calculation
Date: Fri,  6 Feb 2009 15:12:50 +0800
Message-Id: <1233904388-5765-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
References: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Fix erroneous SPI Clock divisor calculation. Make sure SPI_BAUD is
always >= 2. Writing a value of 0 or 1 to the SPI_BAUD register disables
the serial clock.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
---
 arch/blackfin/include/asm/bfin5xx_spi.h |    2 ++
 drivers/spi/spi_bfin5xx.c               |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/include/asm/bfin5xx_spi.h b/arch/blackfin/include/asm/bfin5xx_spi.h
index 1306e6b..e1bb164 100644
--- a/arch/blackfin/include/asm/bfin5xx_spi.h
+++ b/arch/blackfin/include/asm/bfin5xx_spi.h
@@ -11,6 +11,8 @@
 #ifndef _SPI_CHANNEL_H_
 #define _SPI_CHANNEL_H_
 
+#define MIN_SPI_BAUD_VAL	2
+
 #define SPI_READ              0
 #define SPI_WRITE             1
 
diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
index 590f975..f2e18f7 100644
--- a/drivers/spi/spi_bfin5xx.c
+++ b/drivers/spi/spi_bfin5xx.c
@@ -158,6 +158,9 @@ static u16 hz_to_spi_baud(u32 speed_hz)
 	if ((sclk % (2 * speed_hz)) > 0)
 		spi_baud++;
 
+	if (spi_baud < MIN_SPI_BAUD_VAL)
+		spi_baud = MIN_SPI_BAUD_VAL;
+
 	return spi_baud;
 }
 
-- 
1.5.6.3
