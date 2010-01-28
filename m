Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570Ab0A1UDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab0A1UDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304Ab0A1UDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:03:18 -0500
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:51109 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab0A1UDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:03:17 -0500
Date: Thu, 28 Jan 2010 20:57:12 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] winbond-cir: remove dmesg spam
Message-ID: <20100128195712.GA9005@hardeman.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I missed converting one dev_info call to deb_dbg before submitting the driver.
Without this change, a message will be printed to dmesg for each button press
if a RC6 remote is used.

Signed-off-by: David Härdeman <david@hardeman.nu>
Cc: stable <stable@kernel.org>
---
 drivers/input/misc/winbond-cir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/winbond-cir.c b/drivers/input/misc/winbond-cir.c
index 33309fe..c8f5a9a 100644
--- a/drivers/input/misc/winbond-cir.c
+++ b/drivers/input/misc/winbond-cir.c
@@ -768,7 +768,7 @@ wbcir_parse_rc6(struct device *dev, struct wbcir_data *data)
 		return;
 	}
 
-	dev_info(dev, "IR-RC6 ad 0x%02X cm 0x%02X cu 0x%04X "
+	dev_dbg(dev, "IR-RC6 ad 0x%02X cm 0x%02X cu 0x%04X "
 		"toggle %u mode %u scan 0x%08X\n",
 		address,
 		command,
-- 
1.6.6

