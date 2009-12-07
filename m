Return-Path: <linux-kernel-owner+w=401wt.eu-S935057AbZLGN34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935057AbZLGN34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935014AbZLGN3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:29:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:9603 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934940AbZLGN3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:29:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=UPuKFKmVJb2M1sxKS/wS+8cw1H25fwYTnZUEJK76aGAdb6tzVphk2/vYfAc7NQnYav
         by0qGwndwar2kSUYgsgOuesV/TLnyM2uPytI2fTFXsZWVomEFPugElRzbjRZ7yGJrwY/
         0QRWUBP7PqipMJwjHnFX17euXhb1tqbLZTuoE=
Message-ID: <4B1D0399.2070307@gmail.com>
Date: Mon, 07 Dec 2009 14:31:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] s390: PTR_ERR return of wrong pointer in fallback_init_cip()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/s390/crypto/aes_s390.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 6118890..6be4503 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -174,7 +174,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
 	if (IS_ERR(sctx->fallback.cip)) {
 		pr_err("Allocating AES fallback algorithm %s failed\n",
 		       name);
-		return PTR_ERR(sctx->fallback.blk);
+		return PTR_ERR(sctx->fallback.cip);
 	}
 
 	return 0;
