Return-Path: <linux-kernel-owner+w=401wt.eu-S939318AbXFHHsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939318AbXFHHsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938404AbXFHHYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:55 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55296 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938157AbXFHHYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:51 -0400
Message-Id: <20070608072220.006310000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:01 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 34/54] Fix roundup_pow_of_two(1)
Content-Disposition: inline; filename=fix-roundup_pow_of_two.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Fix roundup_pow_of_two(1)

1 is a power of two, therefore roundup_pow_of_two(1) should return 1. It does
in case the argument is a variable but in case it's a constant it behaves
wrong and returns 0. Probably nobody ever did it so this was never noticed.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 include/linux/log2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.4.orig/include/linux/log2.h
+++ linux-2.6.21.4/include/linux/log2.h
@@ -159,7 +159,7 @@ unsigned long __roundup_pow_of_two(unsig
 #define roundup_pow_of_two(n)			\
 (						\
 	__builtin_constant_p(n) ? (		\
-		(n == 1) ? 0 :			\
+		(n == 1) ? 1 :			\
 		(1UL << (ilog2((n) - 1) + 1))	\
 				   ) :		\
 	__roundup_pow_of_two(n)			\

-- 
