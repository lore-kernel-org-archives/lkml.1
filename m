Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZKHMWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZKHMWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 07:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbZKHMWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 07:22:18 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:59077 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbZKHMWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 07:22:14 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
Subject: [PATCH 02/23] sysctl: Stop using binary sysctl numbers in arlan.
Date: Sun,  8 Nov 2009 04:21:49 -0800
Message-Id: <1257682930-31401-2-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m14op5jjo4.fsf@fess.ebiederm.org>
References: <m14op5jjo4.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Looking at the arlan code it appears all of the sysctl
entries are disabled debug code, and have not been enabled
since the driver was merged in feb of 2003.

Since except for a select few that userspace can't
get along without the binary sysctl table entries
are going away.  Kill the unused arlan binary sysctls.

Cc: John W. Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/net/wireless/arlan-proc.c |  181 ++++++++++++++-----------------------
 1 files changed, 69 insertions(+), 112 deletions(-)

diff --git a/drivers/net/wireless/arlan-proc.c b/drivers/net/wireless/arlan-proc.c
index a8b6896..66a0b33 100644
--- a/drivers/net/wireless/arlan-proc.c
+++ b/drivers/net/wireless/arlan-proc.c
@@ -816,84 +816,83 @@ static int arlan_sysctl_reset(ctl_table * ctl, int write,
 
 
 /* Place files in /proc/sys/dev/arlan */
-#define CTBLN(num,card,nam) \
-        { .ctl_name = num,\
-          .procname = #nam,\
+#define CTBLN(card,nam) \
+        { .procname = #nam,\
           .data = &(arlan_conf[card].nam),\
           .maxlen = sizeof(int), .mode = 0600, .proc_handler = &proc_dointvec}
 #ifdef ARLAN_DEBUGGING
 
 #define ARLAN_PROC_DEBUG_ENTRIES \
-        { .ctl_name = 48, .procname = "entry_exit_debug",\
+        { .procname = "entry_exit_debug",\
           .data = &arlan_entry_and_exit_debug,\
           .maxlen = sizeof(int), .mode = 0600, .proc_handler = &proc_dointvec},\
-	{ .ctl_name = 49, .procname = "debug", .data = &arlan_debug,\
+	{ .procname = "debug", .data = &arlan_debug,\
           .maxlen = sizeof(int), .mode = 0600, .proc_handler = &proc_dointvec},
 #else 
 #define ARLAN_PROC_DEBUG_ENTRIES
 #endif
 
 #define ARLAN_SYSCTL_TABLE_TOTAL(cardNo)\
-	CTBLN(1,cardNo,spreadingCode),\
-	CTBLN(2,cardNo, channelNumber),\
-	CTBLN(3,cardNo, scramblingDisable),\
-	CTBLN(4,cardNo, txAttenuation),\
-	CTBLN(5,cardNo, systemId), \
-	CTBLN(6,cardNo, maxDatagramSize),\
-	CTBLN(7,cardNo, maxFrameSize),\
-	CTBLN(8,cardNo, maxRetries),\
-	CTBLN(9,cardNo, receiveMode),\
-	CTBLN(10,cardNo, priority),\
-	CTBLN(11,cardNo, rootOrRepeater),\
-	CTBLN(12,cardNo, SID),\
-	CTBLN(13,cardNo, registrationMode),\
-	CTBLN(14,cardNo, registrationFill),\
-	CTBLN(15,cardNo, localTalkAddress),\
-	CTBLN(16,cardNo, codeFormat),\
-	CTBLN(17,cardNo, numChannels),\
-	CTBLN(18,cardNo, channel1),\
-	CTBLN(19,cardNo, channel2),\
-	CTBLN(20,cardNo, channel3),\
-	CTBLN(21,cardNo, channel4),\
-	CTBLN(22,cardNo, txClear),\
-	CTBLN(23,cardNo, txRetries),\
-	CTBLN(24,cardNo, txRouting),\
-	CTBLN(25,cardNo, txScrambled),\
-	CTBLN(26,cardNo, rxParameter),\
-	CTBLN(27,cardNo, txTimeoutMs),\
-	CTBLN(28,cardNo, waitCardTimeout),\
-	CTBLN(29,cardNo, channelSet), \
-	{.ctl_name = 30, .procname = "name",\
+	CTBLN(cardNo,spreadingCode),\
+	CTBLN(cardNo, channelNumber),\
+	CTBLN(cardNo, scramblingDisable),\
+	CTBLN(cardNo, txAttenuation),\
+	CTBLN(cardNo, systemId), \
+	CTBLN(cardNo, maxDatagramSize),\
+	CTBLN(cardNo, maxFrameSize),\
+	CTBLN(cardNo, maxRetries),\
+	CTBLN(cardNo, receiveMode),\
+	CTBLN(cardNo, priority),\
+	CTBLN(cardNo, rootOrRepeater),\
+	CTBLN(cardNo, SID),\
+	CTBLN(cardNo, registrationMode),\
+	CTBLN(cardNo, registrationFill),\
+	CTBLN(cardNo, localTalkAddress),\
+	CTBLN(cardNo, codeFormat),\
+	CTBLN(cardNo, numChannels),\
+	CTBLN(cardNo, channel1),\
+	CTBLN(cardNo, channel2),\
+	CTBLN(cardNo, channel3),\
+	CTBLN(cardNo, channel4),\
+	CTBLN(cardNo, txClear),\
+	CTBLN(cardNo, txRetries),\
+	CTBLN(cardNo, txRouting),\
+	CTBLN(cardNo, txScrambled),\
+	CTBLN(cardNo, rxParameter),\
+	CTBLN(cardNo, txTimeoutMs),\
+	CTBLN(cardNo, waitCardTimeout),\
+	CTBLN(cardNo, channelSet), \
+	{ .procname = "name",\
 	 .data = arlan_conf[cardNo].siteName,\
 	 .maxlen = 16, .mode = 0600, .proc_handler = &proc_dostring},\
-	CTBLN(31,cardNo,waitTime),\
-	CTBLN(32,cardNo,lParameter),\
-	CTBLN(33,cardNo,_15),\
-	CTBLN(34,cardNo,headerSize),\
-	CTBLN(36,cardNo,tx_delay_ms),\
-	CTBLN(37,cardNo,retries),\
-	CTBLN(38,cardNo,ReTransmitPacketMaxSize),\
-	CTBLN(39,cardNo,waitReTransmitPacketMaxSize),\
-	CTBLN(40,cardNo,fastReTransCount),\
-	CTBLN(41,cardNo,driverRetransmissions),\
-	CTBLN(42,cardNo,txAckTimeoutMs),\
-	CTBLN(43,cardNo,registrationInterrupts),\
-	CTBLN(44,cardNo,hardwareType),\
-	CTBLN(45,cardNo,radioType),\
-	CTBLN(46,cardNo,writeEEPROM),\
-	CTBLN(47,cardNo,writeRadioType),\
+	CTBLN(cardNo,waitTime),\
+	CTBLN(cardNo,lParameter),\
+	CTBLN(cardNo,_15),\
+	CTBLN(cardNo,headerSize),\
+	CTBLN(cardNo,tx_delay_ms),\
+	CTBLN(cardNo,retries),\
+	CTBLN(cardNo,ReTransmitPacketMaxSize),\
+	CTBLN(cardNo,waitReTransmitPacketMaxSize),\
+	CTBLN(cardNo,fastReTransCount),\
+	CTBLN(cardNo,driverRetransmissions),\
+	CTBLN(cardNo,txAckTimeoutMs),\
+	CTBLN(cardNo,registrationInterrupts),\
+	CTBLN(cardNo,hardwareType),\
+	CTBLN(cardNo,radioType),\
+	CTBLN(cardNo,writeEEPROM),\
+	CTBLN(cardNo,writeRadioType),\
 	ARLAN_PROC_DEBUG_ENTRIES\
-	CTBLN(50,cardNo,in_speed),\
-	CTBLN(51,cardNo,out_speed),\
-	CTBLN(52,cardNo,in_speed10),\
-	CTBLN(53,cardNo,out_speed10),\
-	CTBLN(54,cardNo,in_speed_max),\
-	CTBLN(55,cardNo,out_speed_max),\
-	CTBLN(56,cardNo,measure_rate),\
-	CTBLN(57,cardNo,pre_Command_Wait),\
-	CTBLN(58,cardNo,rx_tweak1),\
-	CTBLN(59,cardNo,rx_tweak2),\
-	CTBLN(60,cardNo,tx_queue_len),\
+	CTBLN(cardNo,in_speed),\
+	CTBLN(cardNo,out_speed),\
+	CTBLN(cardNo,in_speed10),\
+	CTBLN(cardNo,out_speed10),\
+	CTBLN(cardNo,in_speed_max),\
+	CTBLN(cardNo,out_speed_max),\
+	CTBLN(cardNo,measure_rate),\
+	CTBLN(cardNo,pre_Command_Wait),\
+	CTBLN(cardNo,rx_tweak1),\
+	CTBLN(cardNo,rx_tweak2),\
+	CTBLN(cardNo,tx_queue_len),\
 
 
 
@@ -903,7 +902,6 @@ static ctl_table arlan_conf_table0[] =
 
 #ifdef ARLAN_PROC_SHM_DUMP
 	{
-		.ctl_name	= 150,
 		.procname	= "arlan0-txRing",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -911,7 +909,6 @@ static ctl_table arlan_conf_table0[] =
 		.proc_handler	= &arlan_sysctl_infotxRing,
 	},
 	{
-		.ctl_name	= 151,
 		.procname	= "arlan0-rxRing",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -919,7 +916,6 @@ static ctl_table arlan_conf_table0[] =
 		.proc_handler	= &arlan_sysctl_inforxRing,
 	},
 	{
-		.ctl_name	= 152,
 		.procname	= "arlan0-18",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -927,7 +923,6 @@ static ctl_table arlan_conf_table0[] =
 		.proc_handler	= &arlan_sysctl_info18,
 	},
 	{
-		.ctl_name	= 153,
 		.procname	= "arlan0-ring",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -935,7 +930,6 @@ static ctl_table arlan_conf_table0[] =
 		.proc_handler	= &arlan_sysctl_info161719,
 	},
 	{
-		.ctl_name	= 154,
 		.procname	= "arlan0-shm-cpy",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -944,7 +938,6 @@ static ctl_table arlan_conf_table0[] =
 	},
 #endif
 	{
-		.ctl_name	= 155,
 		.procname	= "config0",
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
@@ -952,14 +945,13 @@ static ctl_table arlan_conf_table0[] =
 		.proc_handler	= &arlan_configure
 	},
 	{
-		.ctl_name	= 156,
 		.procname	= "reset0",
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
 		.proc_handler	= &arlan_sysctl_reset,
 	},
-	{ .ctl_name = 0 }
+	{  }
 };
 
 static ctl_table arlan_conf_table1[] =
@@ -969,7 +961,6 @@ static ctl_table arlan_conf_table1[] =
 
 #ifdef ARLAN_PROC_SHM_DUMP
 	{
-		.ctl_name	= 150,
 		.procname	= "arlan1-txRing",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -977,7 +968,6 @@ static ctl_table arlan_conf_table1[] =
 		.proc_handler	= &arlan_sysctl_infotxRing,
 	},
 	{
-		.ctl_name	= 151,
 		.procname	= "arlan1-rxRing",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -985,7 +975,6 @@ static ctl_table arlan_conf_table1[] =
 		.proc_handler	= &arlan_sysctl_inforxRing,
 	},
 	{
-		.ctl_name	= 152,
 		.procname	= "arlan1-18",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -993,7 +982,6 @@ static ctl_table arlan_conf_table1[] =
 		.proc_handler	= &arlan_sysctl_info18,
 	},
 	{
-		.ctl_name	= 153,
 		.procname	= "arlan1-ring",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -1001,7 +989,6 @@ static ctl_table arlan_conf_table1[] =
 		.proc_handler	= &arlan_sysctl_info161719,
 	},
 	{
-		.ctl_name	= 154,
 		.procname	= "arlan1-shm-cpy",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -1010,7 +997,6 @@ static ctl_table arlan_conf_table1[] =
 	},
 #endif
 	{
-		.ctl_name	= 155,
 		.procname	= "config1",
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
@@ -1018,14 +1004,13 @@ static ctl_table arlan_conf_table1[] =
 		.proc_handler	= &arlan_configure,
 	},
 	{
-		.ctl_name	= 156,
 		.procname	= "reset1",
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
 		.proc_handler	= &arlan_sysctl_reset,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static ctl_table arlan_conf_table2[] =
@@ -1035,7 +1020,6 @@ static ctl_table arlan_conf_table2[] =
 
 #ifdef ARLAN_PROC_SHM_DUMP
 	{
-		.ctl_name	= 150,
 		.procname	= "arlan2-txRing",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -1043,7 +1027,6 @@ static ctl_table arlan_conf_table2[] =
 		.proc_handler	= &arlan_sysctl_infotxRing,
 	},
 	{
-		.ctl_name	= 151,
 		.procname	= "arlan2-rxRing",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -1051,7 +1034,6 @@ static ctl_table arlan_conf_table2[] =
 		.proc_handler	= &arlan_sysctl_inforxRing,
 	},
 	{
-		.ctl_name	= 152,
 		.procname	= "arlan2-18",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -1059,7 +1041,6 @@ static ctl_table arlan_conf_table2[] =
 		.proc_handler	= &arlan_sysctl_info18,
 	},
 	{
-		.ctl_name	= 153,
 		.procname	= "arlan2-ring",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -1067,7 +1048,6 @@ static ctl_table arlan_conf_table2[] =
 		.proc_handler	= &arlan_sysctl_info161719,
 	},
 	{
-		.ctl_name	= 154,
 		.procname	= "arlan2-shm-cpy",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -1076,7 +1056,6 @@ static ctl_table arlan_conf_table2[] =
 	},
 #endif
 	{
-		.ctl_name	= 155,
 		.procname	= "config2",
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
@@ -1084,14 +1063,13 @@ static ctl_table arlan_conf_table2[] =
 		.proc_handler	= &arlan_configure,
 	},
 	{
-		.ctl_name	= 156,
 		.procname	= "reset2",
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
 		.proc_handler	= &arlan_sysctl_reset,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 static ctl_table arlan_conf_table3[] =
@@ -1101,7 +1079,6 @@ static ctl_table arlan_conf_table3[] =
 
 #ifdef ARLAN_PROC_SHM_DUMP
 	{
-		.ctl_name	= 150,
 		.procname	= "arlan3-txRing",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -1109,7 +1086,6 @@ static ctl_table arlan_conf_table3[] =
 		.proc_handler	= &arlan_sysctl_infotxRing,
 	},
 	{
-		.ctl_name	= 151,
 		.procname	= "arlan3-rxRing",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -1117,7 +1093,6 @@ static ctl_table arlan_conf_table3[] =
 		.proc_handler	= &arlan_sysctl_inforxRing,
 	},
 	{
-		.ctl_name	= 152,
 		.procname	= "arlan3-18",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -1125,7 +1100,6 @@ static ctl_table arlan_conf_table3[] =
 		.proc_handler	= &arlan_sysctl_info18,
 	},
 	{
-		.ctl_name	= 153,
 		.procname	= "arlan3-ring",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -1133,7 +1107,6 @@ static ctl_table arlan_conf_table3[] =
 		.proc_handler	= &arlan_sysctl_info161719,
 	},
 	{
-		.ctl_name	= 154,
 		.procname	= "arlan3-shm-cpy",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
@@ -1142,7 +1115,6 @@ static ctl_table arlan_conf_table3[] =
 	},
 #endif
 	{
-		.ctl_name	= 155,
 		.procname	= "config3",
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
@@ -1150,14 +1122,13 @@ static ctl_table arlan_conf_table3[] =
 		.proc_handler	= &arlan_configure,
 	},
 	{
-		.ctl_name	= 156,
 		.procname	= "reset3",
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
 		.proc_handler	= &arlan_sysctl_reset,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 
@@ -1165,41 +1136,37 @@ static ctl_table arlan_conf_table3[] =
 static ctl_table arlan_table[] =
 {
 	{
-		.ctl_name	= 0,
 		.procname	= "arlan0",
 		.maxlen		= 0,
 		.mode		= 0600,
 		.child		= arlan_conf_table0,
 	},
 	{
-		.ctl_name	= 0,
 		.procname	= "arlan1",
 		.maxlen		= 0,
 		.mode		= 0600,
 		.child		= arlan_conf_table1,
 	},
 	{
-		.ctl_name	= 0,
 		.procname	= "arlan2",
 		.maxlen		= 0,
 		.mode		= 0600,
 		.child		= arlan_conf_table2,
 	},
 	{
-		.ctl_name	= 0,
 		.procname	= "arlan3",
 		.maxlen		= 0,
 		.mode		= 0600,
 		.child		= arlan_conf_table3,
 	},
-	{ .ctl_name = 0 }
+	{ }
 };
 
 #else
 
-static ctl_table arlan_table[MAX_ARLANS + 1] =
+static ctl_table arlan_table[] =
 {
-	{ .ctl_name = 0 }
+	{ }
 };
 #endif
 
@@ -1209,22 +1176,14 @@ static ctl_table arlan_table[MAX_ARLANS + 1] =
 static ctl_table arlan_root_table[] =
 {
 	{
-		.ctl_name	= CTL_ARLAN,
 		.procname	= "arlan",
 		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= arlan_table,
 	},
-	{ .ctl_name = 0 }
+	{  }
 };
 
-/* Make sure that /proc/sys/dev is there */
-//static ctl_table arlan_device_root_table[] =
-//{
-//	{CTL_DEV, "dev", NULL, 0, 0555, arlan_root_table},
-//	{0}
-//};
-
 
 static struct ctl_table_header *arlan_device_sysctl_header;
 
@@ -1234,8 +1193,6 @@ int __init init_arlan_proc(void)
 	int i = 0;
 	if (arlan_device_sysctl_header)
 		return 0;
-	for (i = 0; i < MAX_ARLANS && arlan_device[i]; i++)
-		arlan_table[i].ctl_name = i + 1;
 	arlan_device_sysctl_header = register_sysctl_table(arlan_root_table);
 	if (!arlan_device_sysctl_header)
 		return -1;
-- 
1.6.5.2.143.g8cc62

