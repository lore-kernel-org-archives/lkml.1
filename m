Return-Path: <linux-kernel-owner+w=401wt.eu-S1761881AbYGOPez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761881AbYGOPez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYGOPeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:34:46 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3567 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbYGOPep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:34:45 -0400
Date: Tue, 15 Jul 2008 11:33:45 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, herbert@gondor.apana.org.au, mingo@elte.hu,
       nhorman@tuxdriver.com
Subject: [crypto] patch to fix bad test definition check in prng
Message-ID: <20080715153345.GE4918@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch to fix bad check of TEST_PRNG_ON_START in prng module.  This should fix
the oopses that simon and ingo recently reported.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 prng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/crypto/prng.c b/crypto/prng.c
index b28f89a..7aeb0d0 100644
--- a/crypto/prng.c
+++ b/crypto/prng.c
@@ -396,7 +396,7 @@ EXPORT_SYMBOL_GPL(reset_prng_context);
 static int __init prng_mod_init(void)
 {
 
-#ifdef TEST_PRNG_ON_START
+#if TEST_PRNG_ON_START
 	int i;
 	unsigned char tmpbuf[DEFAULT_BLK_SZ];
 
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
