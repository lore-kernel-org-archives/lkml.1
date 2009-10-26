Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbZJZIcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbZJZIcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 04:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbZJZIcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 04:32:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:3180 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZJZIcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 04:32:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,625,1249282800"; 
   d="scan'208";a="740450763"
Subject: [BUGFIX] crypto, ghash_clmul_ni, Fix building failure on x86_32
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
       Dave Young <hidave.darkstar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 16:32:12 +0800
Message-Id: <1256545932.30470.31.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLMUL-NI accelerated GHASH should be turned off on non-x86_64 machine.

Reported-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -442,6 +442,7 @@ config CRYPTO_WP512
 
 config CRYPTO_GHASH_CLMUL_NI_INTEL
 	tristate "GHASH digest algorithm (CLMUL-NI accelerated)"
+	depends on (X86 || UML_X86) && 64BIT
 	select CRYPTO_SHASH
 	select CRYPTO_CRYPTD
 	help


