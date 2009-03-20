Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbZCTJJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbZCTJJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 05:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbZCTJJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 05:09:11 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:57303 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZCTJJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 05:09:09 -0400
Date: Fri, 20 Mar 2009 10:09:01 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Alexander Clouter <alex@digriz.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 20 - timeriomem build break on s390
Message-ID: <20090320100901.45ce2e6f@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20090320162800.24b0ad93.sfr@canb.auug.org.au>
References: <20090320162800.24b0ad93.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'hwrng: timeriomem' breaks an allyesconfig build on s390:

  CC      drivers/char/hw_random/timeriomem-rng.o
drivers/char/hw_random/timeriomem-rng.c: In function 'timeriomem_rng_data_read':
drivers/char/hw_random/timeriomem-rng.c:60: error: implicit declaration of function 'readl'

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 drivers/char/hw_random/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-next/drivers/char/hw_random/Kconfig
===================================================================
--- linux-next.orig/drivers/char/hw_random/Kconfig
+++ linux-next/drivers/char/hw_random/Kconfig
@@ -22,7 +22,7 @@ config HW_RANDOM
 
 config HW_RANDOM_TIMERIOMEM
 	tristate "Timer IOMEM HW Random Number Generator support"
-	depends on HW_RANDOM
+	depends on HW_RANDOM && HAS_IOMEM
 	---help---
 	  This driver provides kernel-side support for a generic Random
 	  Number Generator used by reading a 'dumb' iomem address that
