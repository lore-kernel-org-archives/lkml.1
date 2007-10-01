Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbXJAHVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbXJAHVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 03:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbXJAHVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 03:21:42 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:50247 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbXJAHVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 03:21:42 -0400
Date: Mon, 1 Oct 2007 09:21:34 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
Message-ID: <20071001092134.1f3a7c2e@localhost>
In-Reply-To: <47003525.7040407@shaw.ca>
References: <fa.ernzRd7lGBTxTXHl/DtyMhz/rPk@ifi.uio.no>
	<47003525.7040407@shaw.ca>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2007 17:45:41 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> Are you sure this isn't just a bum drive? Looking at the SMART listing 
> that was posted, looks like it's had some uncorrectable sector read 
> errors in the event log..

Don't know. The error count is still 12 today, the differences are:

-------------------------------------------------->
 === START OF INFORMATION SECTION ===
@@ -10,7 +10,7 @@
 Device is:        In smartctl database [for details use: -P show]
 ATA Version is:   6
 ATA Standard is:  ATA/ATAPI-6 T13 1410D revision 2
-Local Time is:    Sun Jan 21 20:15:40 2007 CET
+Local Time is:    Mon Oct  1 09:01:05 2007 CEST
 SMART support is: Available - device has SMART capability.
 SMART support is: Enabled

@@ -48,21 +48,22 @@
 SMART Attributes Data Structure revision number: 10
 Vendor Specific SMART Attributes with Thresholds:
 ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
-  1 Raw_Read_Error_Rate     0x000f   059   049   006    Pre-fail  Always       -       215927244
+  1 Raw_Read_Error_Rate     0x000f   060   047   006    Pre-fail  Always       -       129093793
   3 Spin_Up_Time            0x0003   098   098   000    Pre-fail  Always       -       0
-  4 Start_Stop_Count        0x0032   098   098   020    Old_age   Always       -       2182
+  4 Start_Stop_Count        0x0032   097   097   020    Old_age   Always       -       3094
   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always       -       0
-  7 Seek_Error_Rate         0x000f   083   060   030    Pre-fail  Always       -       204305750
-  9 Power_On_Hours          0x0032   097   097   000    Old_age   Always       -       3494
+  7 Seek_Error_Rate         0x000f   084   060   030    Pre-fail  Always       -       298020973
+  9 Power_On_Hours          0x0032   094   094   000    Old_age   Always       -       5274
  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
- 12 Power_Cycle_Count       0x0032   098   098   020    Old_age   Always       -       2541
-194 Temperature_Celsius     0x0022   024   040   000    Old_age   Always       -       24 (Lifetime Min/Max 0/15)
-195 Hardware_ECC_Recovered  0x001a   059   049   000    Old_age   Always       -       215927244
+ 12 Power_Cycle_Count       0x0032   097   097   020    Old_age   Always       -       3457
+194 Temperature_Celsius     0x0022   023   040   000    Old_age   Always       -       23 (Lifetime Min/Max 0/15)
+195 Hardware_ECC_Recovered  0x001a   060   047   000    Old_age   Always       -       129093793
 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       1
 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       1
 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
 200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age   Offline      -       0
 202 TA_Increase_Count       0x0032   100   253   000    Old_age   Always       -       0

<-------------------------------

Moreover the five logged errors are all about the same sector:
----------------------------------------------------------------------------
Error 12 occurred at disk power-on lifetime: 2516 hours (104 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 0d 5b 9d 34 e1  Error: UNC 13 sectors at LBA = 0x01349d5b = 20225371
-----------------------------------------------------------------------------



That sector isn't in mine XFS partition (sda1):

               First       Last
 # Type       Sector      Sector   Offset    Length   Filesystem Type (ID) Flag
-- ------- ----------- ----------- ------ ----------- -------------------- ----
 1 Primary           0    20000924*    63    20000925*Linux (83)           Boot
 2 Primary    20000925*  156296384      0   136295460 Extended (05)        None
 5 Logical    20000925*   20161574*    63      160650 Linux (83)           None
 6 Logical    20161575*  120166199     63   100004625 Linux (83)           None
 7 Logical   120166200   122174324     63     2008125 Linux swap / So (82) None
 8 Logical   122174325   156296384     63    34122060 Linux (83)           None



So I don't know. To me it looks like these errors are not related...

-- 
	Paolo Ornati
	Linux 2.6.23-rc8-ga64314e6 on x86_64
