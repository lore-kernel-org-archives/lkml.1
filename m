Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbZHQBdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbZHQBdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 21:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbZHQBdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 21:33:10 -0400
Received: from dns.mlb.co.jp ([210.251.64.148]:43950 "EHLO mail.mlb.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbZHQBdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 21:33:09 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Aug 2009 21:33:09 EDT
Date: Mon, 17 Aug 2009 10:24:08 +0900 (JST)
Message-Id: <20090817.102408.159676517.ito@mlb.co.jp>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] MTD: jedec_probe: Fix NEC uPD29F064115 detection.
From: Hiroshi Ito <ito@mlb.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux v2.6.31-rc6 can not detect NEC uPD29F064115.

uPD29F064115 is a 16 bit device.
datasheet:
  http://www.cn.necel.com/memory/cn/download/M16062EJ2V0DS00.pdf

A problem and fix is described as following commit, which in the main
kernel tree, uPD29F064115 needs same fix.

commit ca6f12c67ed19718cf37d0f531af9438de85b70c
Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Date:   Wed Jul 16 00:09:15 2008 +0900

    [MTD] jedec_probe: Fix SST 16-bit chip detection

    The unlock_addr rework in kernel 2.6.25 breaks 16-bit SST chips.  SST
    39LF160 and SST 39VF1601 are both 16-bit only chip (do not have BYTE#
    pin) and new uaddr value is not correct for them.  Add
    MTD_UADDR_0xAAAA_0x5555 for those chips.  Tested with SST 39VF1601
    chip.
    
    Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>


Signed-off-by: Hiroshi Ito <ito@mlb.co.jp>
---
 drivers/mtd/chips/jedec_probe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index ccc4cfc..0f7065d 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -1156,8 +1156,8 @@ static const struct amd_flash_info jedec_table[] = {
 		.mfr_id		= MANUFACTURER_NEC,
 		.dev_id		= UPD29F064115,
 		.name		= "NEC uPD29F064115",
-		.devtypes	= CFI_DEVICETYPE_X16|CFI_DEVICETYPE_X8,
-		.uaddr		= MTD_UADDR_0x0555_0x02AA,	/* ???? */
+		.devtypes	= CFI_DEVICETYPE_X16,
+		.uaddr		= MTD_UADDR_0xAAAA_0x5555,
 		.dev_size	= SIZE_8MiB,
 		.cmd_set	= P_ID_AMD_STD,
 		.nr_regions	= 3,
-- 
1.5.6.5

--------
Hiroshi Ito
Media Lab. Inc.,
URL http://www.mlb.co.jp ( Sorry, Japanese only. )
TEL +81-3-5294-7255  FAX +81-3-5294-7256
