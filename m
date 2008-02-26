Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbYBZM3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbYBZM3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 07:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYBZM3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 07:29:09 -0500
Received: from stinky.trash.net ([213.144.137.162]:49428 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbYBZM3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 07:29:08 -0500
Message-ID: <47C40603.8060908@trash.net>
Date: Tue, 26 Feb 2008 13:28:51 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Martin Michlmayr <tbm@cyrius.com>
CC: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: 2.6.25-rc3: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
References: <20080226122100.GB22699@deprecation.cyrius.com>
In-Reply-To: <20080226122100.GB22699@deprecation.cyrius.com>
Content-Type: multipart/mixed;
 boundary="------------040700060804060003090708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040700060804060003090708
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Martin Michlmayr wrote:
> With 2.6.25-rc3 and a config file with
>
> CONFIG_CRYPTO_DEV_HIFN_795X=m
> CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
>
> I get the following build error on at least ARM and MIPS:
>
>   Building modules, stage 2.
>   MODPOST 759 modules
> ERROR: "__divdi3" [drivers/crypto/hifn_795x.ko] undefined!
>   

Does this patch fix it?



--------------040700060804060003090708
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 3110bf7..92c53ce 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -825,8 +825,8 @@ static int hifn_register_rng(struct hifn_device *dev)
 	/*
 	 * We must wait at least 256 Pk_clk cycles between two reads of the rng.
 	 */
-	dev->rng_wait_time	= DIV_ROUND_UP(NSEC_PER_SEC, dev->pk_clk_freq) *
-				  256;
+	dev->rng_wait_time	= DIV_ROUND_UP((unsigned int)NSEC_PER_SEC,
+					       dev->pk_clk_freq) * 256;
 
 	dev->rng.name		= dev->name;
 	dev->rng.data_present	= hifn_rng_data_present,

--------------040700060804060003090708--
