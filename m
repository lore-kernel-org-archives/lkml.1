Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791Ab0A2J32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab0A2J32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756434Ab0A2J3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:29:24 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53133 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab0A2J3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:29:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=DvMbDo8RhphupMRCqQFrPGL+8GY/5m3YWKwIcXzF0vq2QKmnlUvkE1RpmDrz8R2IpJ
         40Denzjt+MRiYTmZ77WG/oS529G/qy0DehnRaI50e3LZvPCNmL+aDIuoksXwax/BHLNk
         8OS72nr0OO7uo0ZRZ//HW/EZJ+bE/yISX2gS0=
Message-ID: <4B62ABC8.7080607@gmail.com>
Date: Fri, 29 Jan 2010 10:35:04 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mtd: Change positive error return into negative in mtd_do_writeoob()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The error return should be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/mtd/mtdchar.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 5b081cb..01d5837 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -373,7 +373,7 @@ static int mtd_do_writeoob(struct file *file, struct mtd_info *mtd,
 	if (!mtd->write_oob)
 		ret = -EOPNOTSUPP;
 	else
-		ret = access_ok(VERIFY_READ, ptr, length) ? 0 : EFAULT;
+		ret = access_ok(VERIFY_READ, ptr, length) ? 0 : -EFAULT;
 
 	if (ret)
 		return ret;
