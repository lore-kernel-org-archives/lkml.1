Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYBITx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYBITx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 14:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbYBITxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 14:53:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:23327 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbYBITxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 14:53:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:sender;
        b=igslNiCUD39kdbEQhgwFOraP0qLzTpGphqGwmDZpkZwbNWXwAI+FkRDtcvBOMn1Nk/x7A3ACgW6GHS0eG0nnCGSM36Ue4cwwniayCjSsPKmX7C3L8Ed6ey/BIUcCn3Et0fSEBWpSXNFmNBPn9XXxRTw42kReO9kLCJaULmFYG4w=
Date: Sat, 9 Feb 2008 20:52:32 +0100
From: Frederik Deweerdt <deweerdt@free.fr>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org
Subject: [patch] crypto test build failure
Message-ID: <20080209195232.GC11728@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Herbert,

Building latest git fails with the following error:
	ERROR: "crypto_alloc_ablkcipher" [crypto/tcrypt.ko] undefined!
This appears to happen because CONFIG_CRYPTO_TEST is set while
CONFIG_CRYPTO_BLKCIPHER is not.
The following patch fixes the problem for me.

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index c3166a1..d0287ce 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -567,6 +567,7 @@ config CRYPTO_TEST
 	depends on m
 	select CRYPTO_ALGAPI
 	select CRYPTO_AEAD
+	select CRYPTO_BLKCIPHER
 	help
 	  Quick & dirty crypto test module.
 
