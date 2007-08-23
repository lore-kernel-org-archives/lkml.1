Return-Path: <linux-kernel-owner+w=401wt.eu-S933716AbXHWXyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716AbXHWXyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763512AbXHWXyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:54:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:55496 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763170AbXHWXyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=YYWXXBOmFySZWDl6YElQ4U+K1YoyOJROhUzRVDRWIYTo3Es4UePtLpY+KLc8vEwZ6tM9HTt55bUimHoN83L+03AQEzChOjWHB7VaZnE79sGY3Jte+TdAocTIyCRsl5oor/mmCngiG8iRX/4h3nk1hkC2/8kPHT1REHnGPReWoF0=
Message-Id: <1d6727f1f17e3ccd2986154ff549d5ffeb1884fe.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 01:51:44 +0200
Subject: [PATCH 08/30] mtd: Avoid a pointless kmalloc() return value cast in TQM8xxL mapping handling code
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Kirk Lee <kirk@hpc.ee.ntu.edu.tw>, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/mtd/maps/tqm8xxl.c::init_tqm_mtd() it is pointless casting
the return value of kmalloc() since it returns void*.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 drivers/mtd/maps/tqm8xxl.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/maps/tqm8xxl.c b/drivers/mtd/maps/tqm8xxl.c
index 37e4ded..1d75ce4 100644
--- a/drivers/mtd/maps/tqm8xxl.c
+++ b/drivers/mtd/maps/tqm8xxl.c
@@ -141,8 +141,7 @@ int __init init_tqm_mtd(void)
 			goto error_mem;
 		}
 
-		map_banks[idx]->name = (char *)kmalloc(16, GFP_KERNEL);
-
+		map_banks[idx]->name = kmalloc(16, GFP_KERNEL);
 		if (!map_banks[idx]->name) {
 			ret = -ENOMEM;
 			/* FIXME: What if some MTD devices were probed already? */
-- 
1.5.2.2

