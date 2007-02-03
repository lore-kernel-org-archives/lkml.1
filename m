Return-Path: <linux-kernel-owner+w=401wt.eu-S1946289AbXBCCrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946289AbXBCCrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946258AbXBCCne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:43:34 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53550 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946276AbXBCCnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:43:31 -0500
Message-Id: <20070203024544.595668000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:52 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Bob Breuer <breuerr@mc.net>
Subject: [patch 48/59] SPARC32: Fix over-optimization by GCC near ip_fast_csum.
Content-Disposition: inline; filename=sparc32-fix-over-optimization-by-gcc-near-ip_fast_csum.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Bob Breuer <breuerr@mc.net>

In some cases such as:
	iph->check = 0;
	iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
GCC may optimize out the previous store.

Observed as a failure of NFS over udp (bad checksums on ip fragments)
when compiled with GCC 3.4.2.

Signed-off-by: Bob Breuer <breuerr@mc.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/asm-sparc/checksum.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19.2.orig/include/asm-sparc/checksum.h
+++ linux-2.6.19.2/include/asm-sparc/checksum.h
@@ -159,7 +159,7 @@ static inline unsigned short ip_fast_csu
 			     "xnor\t%%g0, %0, %0"
 			     : "=r" (sum), "=&r" (iph)
 			     : "r" (ihl), "1" (iph)
-			     : "g2", "g3", "g4", "cc");
+			     : "g2", "g3", "g4", "cc", "memory");
 	return sum;
 }
 

--
