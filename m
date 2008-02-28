Return-Path: <linux-kernel-owner+w=401wt.eu-S1760448AbYB1Rk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760448AbYB1Rk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYB1RkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:40:13 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:30898 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbYB1RkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:40:12 -0500
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>,
       Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [WATCHDOG] Fix declaration of struct smbios_entry_point in hpwdt
X-Message-Flag: Warning: May contain useful information
References: <adad4qiwcmz.fsf@cisco.com>
	<alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de>
	<ada1w6y1bzk.fsf@cisco.com>
	<alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de>
	<20080227203655.GA30054@elte.hu>
	<alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de>
	<alpine.LFD.1.00.0802272155190.7583@apollo.tec.linutronix.de>
	<ada3areyu7x.fsf@cisco.com>
	<E14D1C2A44812C4F9C3ED321127EDF6505829D59DF@G3W0854.americas.hpqcorp.net>
	<adamypmx7k1.fsf@cisco.com>
	<E14D1C2A44812C4F9C3ED321127EDF6505829D5D6C@G3W0854.americas.hpqcorp.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 28 Feb 2008 09:38:44 -0800
In-Reply-To: <E14D1C2A44812C4F9C3ED321127EDF6505829D5D6C@G3W0854.americas.hpqcorp.net> (Thomas Mingarelli's message of "Thu, 28 Feb 2008 15:02:36 +0000")
Message-ID: <adaejaxx9p7.fsf_-_@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Feb 2008 17:38:49.0831 (UTC) FILETIME=[C7272770:01C87A30]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my HP DL380 G5 system running a 64-bit kernel, loading the hpwdt
driver causes a crash because the driver attempts to ioremap an
invalid physical address.  This is because the driver has an incorrect
definition of the SMBIOS table entry point structure: the table
address is only a 32-bit quantity, and making it a u64 means that the
high-order 32 bits end up containing garbage.

Correcting the structure definition fixes the driver so that it loads
without any problems on my system.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a2e174b..cd1cc2d 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -88,7 +88,7 @@ struct smbios_entry_point {
 	u8 intermediate_anchor[5];
 	u8 intermediate_checksum;
 	u16 table_length;
-	u64 table_address;
+	u32 table_address;
 	u16 table_num_structs;
 	u8 bcd_revision;
 };
