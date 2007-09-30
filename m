Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbXI3OHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbXI3OHQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 10:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756417AbXI3OHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 10:07:06 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:36071 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbXI3OHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 10:07:04 -0400
Date: Sun, 30 Sep 2007 16:05:48 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
Message-ID: <20070930160548.235be972@localhost>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I think you forgot to blacklist this one  :)

--
Seagate Barracuda ST380817AS has troubles with NCQ. For example,
unpacking a tarball on an XFS filesystem gives this:

ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
ata1.00: cmd 61/40:00:29:a3:98/00:00:00:00:00/40 tag 0 cdb 0x0 data 32768 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)

More info here:
http://lkml.org/lkml/2007/1/21/76
    
Blacklist it!
    
Signed-off-by: Paolo Ornati <ornati@fastwebnet.it>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 772be09..be289d0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3781,6 +3781,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "Maxtor 7B250S0",	"BANC1B70",	ATA_HORKAGE_NONCQ, },
 	{ "Maxtor 7B300S0",	"BANC1B70",	ATA_HORKAGE_NONCQ },
 	{ "Maxtor 7V300F0",	"VA111630",	ATA_HORKAGE_NONCQ },
+	{ "ST380817AS",		"3.42",		ATA_HORKAGE_NONCQ },
 	{ "HITACHI HDS7250SASUN500G 0621KTAWSD", "K2AOAJ0AHITACHI",
 	 ATA_HORKAGE_NONCQ },
 	/* NCQ hard hangs device under heavier load, needs hard power cycle */


-- 
	Paolo Ornati
	Linux 2.6.23-rc8-ga64314e6-dirty on x86_64
