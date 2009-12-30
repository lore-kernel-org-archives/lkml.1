Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZL3TW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZL3TW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZL3TW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:22:28 -0500
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:57295 "HELO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752692AbZL3TW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:22:28 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/message/i2o/i2o_proc.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 14:22:28 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F659@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] drivers/message/i2o/i2o_proc.c: use %pM to show MAC address
Thread-Index: AcqJhW0NyiLLZHkQRv6s67xgNHfTbg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Dec 2009 19:22:26.0927 (UTC) FILETIME=[6C02F7F0:01CA8985]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

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
