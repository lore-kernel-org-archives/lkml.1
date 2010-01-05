Return-Path: <linux-kernel-owner+w=401wt.eu-S932107Ab0AERDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab0AERDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932077Ab0AERDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:03:23 -0500
Received: from [206.15.93.42] ([206.15.93.42]:9423 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754611Ab0AERDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:03:22 -0500
X-Greylist: delayed 1075 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 12:03:20 EST
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/message/i2o/i2o_proc.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:51:29 -0700
Cc: davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050951.29680.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

diff --git a/drivers/message/i2o/i2o_proc.c b/drivers/message/i2o/i2o_proc.c
index 7045c45..949a648 100644
--- a/drivers/message/i2o/i2o_proc.c
+++ b/drivers/message/i2o/i2o_proc.c
@@ -111,10 +111,7 @@ static int print_serial_number(struct seq_file *seq, u8 * serialno, int max_len)
 		break;
 
 	case I2O_SNFORMAT_LAN48_MAC:	/* LAN-48 MAC Address */
-		seq_printf(seq,
-			   "LAN-48 MAC address @ %02X:%02X:%02X:%02X:%02X:%02X",
-			   serialno[2], serialno[3],
-			   serialno[4], serialno[5], serialno[6], serialno[7]);
+		seq_printf(seq, "LAN-48 MAC address @ %pM", &serialno[2]);
 		break;
 
 	case I2O_SNFORMAT_WAN:	/* WAN MAC Address */
@@ -126,10 +123,8 @@ static int print_serial_number(struct seq_file *seq, u8 * serialno, int max_len)
 	case I2O_SNFORMAT_LAN64_MAC:	/* LAN-64 MAC Address */
 		/* FIXME: Figure out what a LAN-64 address really looks like?? */
 		seq_printf(seq,
-			   "LAN-64 MAC address @ [?:%02X:%02X:?] %02X:%02X:%02X:%02X:%02X:%02X",
-			   serialno[8], serialno[9],
-			   serialno[2], serialno[3],
-			   serialno[4], serialno[5], serialno[6], serialno[7]);
+			   "LAN-64 MAC address @ [?:%02X:%02X:?] %pM",
+			   serialno[8], serialno[9], &serialno[2]);
 		break;
 
 	case I2O_SNFORMAT_DDM:	/* I2O DDM */
