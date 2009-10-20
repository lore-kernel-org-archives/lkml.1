Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZJTGEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZJTGEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZJTGEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:04:45 -0400
Received: from biz49.inmotionhosting.com ([74.124.203.185]:39609 "EHLO
	biz49.inmotionhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbZJTGEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:04:44 -0400
X-Greylist: delayed 17589 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Oct 2009 02:04:44 EDT
Message-ID: <36176.167.216.14.194.1256001083.squirrel@www.concentris-systems.com>
Date: Mon, 19 Oct 2009 15:11:23 -1000 (HST)
Subject: [PATCH] RTC: v3020 driver bugfix
From: "Scott Valentine" <svalentine@concentris-systems.com>
To: rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, raph@8d.com, linux-kernel@vger.kernel.org
Reply-To: svalentine@concentris-systems.com
User-Agent: SquirrelMail/1.4.13
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - biz49.inmotionhosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - concentris-systems.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3020 read_bit always returns 0 when left_shift > 7

The v3020 read_bit function's return type is (unsigned char). The code
returns a value masked by (1 << left_shift) that is casted to the return
type. If left_shift is larger than 7, the cast will always result in a 0
return value. The problem was discovered with left_shift = 16, and the
included patch corrects the problem.

The bug was introduced in the last (Apr 3 2009) commit of the file, kernel
versions 2.6.30 and later.

diff -uNr a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
--- a/drivers/rtc/rtc-v3020.c   2009-10-15 14:41:50.000000000 -1000
+++ b/drivers/rtc/rtc-v3020.c   2009-10-19 14:06:27.000000000 -1000
@@ -96,7 +96,7 @@

 static unsigned char v3020_mmio_read_bit(struct v3020 *chip)
 {
-       return readl(chip->ioaddress) & (1 << chip->leftshift);
+       return ((readl(chip->ioaddress) & (1 << chip->leftshift)) != 0);
 }

 static struct v3020_chip_ops v3020_mmio_ops = {




Scott Valentine

Concentris Systems LLC
Manoa Innovation Center, Suite #238
2800 Woodlawn Drive
Honolulu, HI  96822

http://www.Concentris-Systems.com


