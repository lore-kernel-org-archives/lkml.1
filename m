Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZEWJJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZEWJJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 05:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZEWJJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 05:09:45 -0400
Received: from smtp.nokia.com ([192.100.105.134]:41215 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZEWJJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 05:09:45 -0400
Subject: Re: [PATCH] plat_nand: add missing __devexit_p()
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <1242634081-16593-1-git-send-email-vapier@gentoo.org>
References: <1242634081-16593-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 May 2009 12:09:08 +0300
Message-Id: <1243069748.21646.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 May 2009 09:09:12.0915 (UTC) FILETIME=[23C78A30:01C9DB86]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 04:08 -0400, Mike Frysinger wrote:
> The remove function uses __devexit, so the .remove assignment needs
> __devexit_p() to fix a build error with hotplug disabled.

I already have a patch for this in my l2-mtd-2.6.git tree:

commit 486dd2676fd0dc0f944ce142a57cda8772eec118
Author: Thomas Chou <thomas@wytron.com.tw>
Date:   Tue Apr 21 12:27:34 2009 +0800

    MTD: plat_nand: fix section error

    With CONFIG_HOTPLUG=n, the following eror occurred during link:
    local symbol 0: discarded in section `.devexit.text' from
    drivers/built-in.o

    It was caused by improper section reference. The __devexit_p()
    should be added to the .remove function.

    Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index 86e1d08..28ffd4e 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -128,7 +128,7 @@ static int __devexit plat_nand_remove(struct
platform_device *pdev)

 static struct platform_driver plat_nand_driver = {
        .probe          = plat_nand_probe,
-       .remove         = plat_nand_remove,
+       .remove         = __devexit_p(plat_nand_remove),
        .driver         = {
                .name   = "gen_nand",
                .owner  = THIS_MODULE,

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

