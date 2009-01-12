Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbZALIOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbZALIOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 03:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZALIOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 03:14:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:41125 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbZALIOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 03:14:05 -0500
Subject: Re: 2.6.28-git8: tg3 doesn't work due to firmware not loading
 (-git7 is ok)
From: David Woodhouse <dwmw2@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: David Miller <davem@davemloft.net>, alessandro.suardi@gmail.com,
       jaswinderlinux@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <4407.1231719036@turing-police.cc.vt.edu>
References: <5a4c581d0901090930j5d4760b0x730b5609fa2b5614@mail.gmail.com>
	 <20090109.140422.60087297.davem@davemloft.net>
	 <43805.1231672258@turing-police.cc.vt.edu>
	 <20090111.040842.86784676.davem@davemloft.net>
	 <1231676698.25018.147.camel@macbook.infradead.org>
	 <1231678799.25018.195.camel@macbook.infradead.org>
	 <4407.1231719036@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 08:13:59 +0000
Message-Id: <1231748039.25018.1277.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-2.fc10) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 19:10 -0500, Valdis.Kletnieks@vt.edu wrote:
> So it looks like the patch is failing to finish initialization of the card.
> Damned if *I* can see what's breaking it, the conversion to use a helper
> function tg3_request_firmware seems sane enough....

Ahem...

--- drivers/net/tg3.c.stupiddwmw2	2009-01-12 08:13:05.000000000 +0000
+++ drivers/net/tg3.c	2009-01-12 08:13:09.000000000 +0000
@@ -13151,7 +13151,7 @@ static int __devinit tg3_init_one(struct
 		   try again in tg3_open(). So if you have the driver built
 		   into the kernel, you can still get the firmware loaded
 		   after userspace is running, when the device comes up. */
-		if (err != -ENOENT)
+		if (err && err != -ENOENT)
 			goto err_out_fw;
 	}
 

-- 
dwmw2

