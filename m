Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbZLKP3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbZLKP3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbZLKP3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:29:43 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:45882 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758469AbZLKP3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:29:42 -0500
Date: Fri, 11 Dec 2009 23:29:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: hwrng: pasemi - Use __devexit_p
Message-ID: <20091211152947.GA1012@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found this while trying to track down section mismatches in hwrng.

commit af304da7bbc35a72828cd8c5ef3c4e62ddaf0518
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Dec 11 23:13:33 2009 +0800

    hwrng: pasemi - Use __devexit_p
    
    We must wrap __devexit functions with __devexit_p.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
index 7fa61dd..5ec40af 100644
--- a/drivers/char/hw_random/pasemi-rng.c
+++ b/drivers/char/hw_random/pasemi-rng.c
@@ -143,7 +143,7 @@ static struct of_platform_driver rng_driver = {
 	.name		= "pasemi-rng",
 	.match_table	= rng_match,
 	.probe		= rng_probe,
-	.remove		= rng_remove,
+	.remove		= __devexit_p(rng_remove),
 };
 
 static int __init rng_init(void)
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
