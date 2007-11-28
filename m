Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbXK1OWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbXK1OWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 09:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbXK1OWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 09:22:14 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:57424 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752679AbXK1OWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 09:22:13 -0500
Date: Wed, 28 Nov 2007 19:52:01 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, olof@lixom.net, apw@shadowen.org,
       balbir@linux.vnet.ibm.com
Subject: [PATCH] 2.6.24-rc3-mm2 build failure pasemi-rng driver
Message-ID: <20071128142201.GA487@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071128034140.648383f0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kerne build fails, with message

  CC      drivers/char/hw_random/pasemi-rng.o
drivers/char/hw_random/pasemi-rng.c: In function ‘pasemi_rng_data_present’:
drivers/char/hw_random/pasemi-rng.c:53: error: ‘wait’ undeclared (first use in this function)
drivers/char/hw_random/pasemi-rng.c:53: error: (Each undeclared identifier is reported only once
drivers/char/hw_random/pasemi-rng.c:53: error: for each function it appears in.)
drivers/char/hw_random/pasemi-rng.c: At top level:
drivers/char/hw_random/pasemi-rng.c:93: warning: initialization from incompatible pointer type
make[3]: *** [drivers/char/hw_random/pasemi-rng.o] Error 1
make[2]: *** [drivers/char/hw_random] Error 2
make[1]: *** [drivers/char] Error 2
make: *** [drivers] Error 2

Tested for build failure, only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.24-rc3/drivers/char/hw_random/pasemi-rng.c	2007-11-28 17:47:41.000000000 +0530
+++ linux-2.6.24-rc3/drivers/char/hw_random/~pasemi-rng.c	2007-11-28 19:43:10.000000000 +0530
@@ -42,7 +42,7 @@
 
 #define MODULE_NAME "pasemi_rng"
 
-static int pasemi_rng_data_present(struct hwrng *rng)
+static int pasemi_rng_data_present(struct hwrng *rng, int wait)
 {
 	void __iomem *rng_regs = (void __iomem *)rng->priv;
 	int data, i;
