Return-Path: <linux-kernel-owner+w=401wt.eu-S1422869AbXBAN26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422869AbXBAN26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422870AbXBAN26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:28:58 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:40826 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422869AbXBAN26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:28:58 -0500
X-Originating-Ip: 74.109.98.130
Date: Thu, 1 Feb 2007 08:28:02 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: achim_leubner@adaptec.com
Subject: [PATCH] SCSI: Fix obvious typo "spin_lock_irqrestore()" in gdth.c.
Message-ID: <Pine.LNX.4.64.0702010824390.14518@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Fix misspelled "spin_lock_irqrestore" to read
"spin_unlock_irqrestore" instead.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 4c698a7..25f7cf4 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -1956,7 +1956,7 @@ static int __init gdth_search_drives(int hanum)
         for (j = 0; j < 12; ++j)
             rtc[j] = CMOS_READ(j);
     } while (rtc[0] != CMOS_READ(0));
-    spin_lock_irqrestore(&rtc_lock, flags);
+    spin_unlock_irqrestore(&rtc_lock, flags);
     TRACE2(("gdth_search_drives(): RTC: %x/%x/%x\n",*(ulong32 *)&rtc[0],
             *(ulong32 *)&rtc[4], *(ulong32 *)&rtc[8]));
     /* 3. send to controller firmware */

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
