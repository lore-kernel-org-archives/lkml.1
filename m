Return-Path: <linux-kernel-owner+w=401wt.eu-S1031547AbXD1Qot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031547AbXD1Qot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031549AbXD1Qot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:44:49 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:46486 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031547AbXD1Qos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:44:48 -0400
Message-ID: <463379FA.9080004@simon.arlott.org.uk>
Date: Sat, 28 Apr 2007 17:44:42 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: herbert@gondor.apana.org.au
Subject: [PATCH] crypto: Use padlock.ko only as a module
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The padlock.ko module is completely useless when compiled in 
because it can't do anything and gets run too early to output 
anything useful:

[    6.052000] padlock: No VIA PadLock drivers have been loaded.
[    6.052000] padlock: Using VIA PadLock ACE for AES algorithm.
[    6.052000] padlock: Using VIA PadLock ACE for SHA1/SHA256 algorithms.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 6059cf8..f0f7a73 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -1,4 +1,6 @@
-obj-$(CONFIG_CRYPTO_DEV_PADLOCK) += padlock.o
+ifeq ($(CONFIG_CRYPTO_DEV_PADLOCK),m)
+obj-m += padlock.o
+endif
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
-- 
1.5.0.1

-- 
Simon Arlott
