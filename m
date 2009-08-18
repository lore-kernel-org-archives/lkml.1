Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbZHRVLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbZHRVLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 17:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZHRVLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 17:11:07 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:47550 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbZHRVLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 17:11:06 -0400
Date: Tue, 18 Aug 2009 23:10:14 +0200 (CEST)
From: dimitri.gorokhovik@free.fr
To: David Woodhouse <dwmw2@infradead.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Scott James Remnant <scott@canonical.com>, Julia Lawall <julia@diku.dk>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <25767218.3393441250629814335.JavaMail.root@zimbra3-e1.priv.proxad.net>
In-Reply-To: <1996041455.3392751250629417929.JavaMail.root@zimbra3-e1.priv.proxad.net>
Subject: [PATCH] nftl: write support is broken
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [79.85.212.132]
X-Mailer: Zimbra 5.0 (ZimbraWebClient - [unknown] (Linux)/5.0.15_GA_2815.UBUNTU8_64)
X-Authenticated-User: dimitri.gorokhovik@free.fr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Write support is broken in NFTL. Fix it.

Signed-off-by: <dimitri.gorokhovik@free.fr>

---

diff --git a/drivers/mtd/nftlcore.c b/drivers/mtd/nftlcore.c
index fb86cac..665d3eb 100644
--- a/drivers/mtd/nftlcore.c
+++ b/drivers/mtd/nftlcore.c
@@ -181,7 +181,7 @@ static int nftl_write(struct mtd_info *mtd, loff_t offs, size_t len,
 	int res;
 
 	ops.mode = MTD_OOB_PLACE;
-	ops.ooboffs = offs;
+	ops.ooboffs = offs & (mtd->writesize - 1);
 	ops.ooblen = mtd->oobsize;
 	ops.oobbuf = oob;
 	ops.datbuf = buf;
