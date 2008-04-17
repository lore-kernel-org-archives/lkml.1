Return-Path: <linux-kernel-owner+w=401wt.eu-S1764709AbYDQBTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764709AbYDQBTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759878AbYDQBII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:08:08 -0400
Received: from sous-sol.org ([216.99.217.87]:58902 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759853AbYDQBIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:08:04 -0400
Message-Id: <20080417010350.133643741@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:05 -0700
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
       "David S. Miller" <davem@davemloft.net>
Subject: SPARC64: Fix atomic backoff limit.
Content-Disposition: inline; filename=sparc64-fix-atomic-backoff-limit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David S. Miller <davem@davemloft.net>

Upstream commit: 4cfea5a7dfcc2766251e50ca30271a782d5004ad

4096 will not fit into the immediate field of a compare instruction,
in fact it will end up being -4096 causing the check to fail every
time and thus disabling backoff.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/asm-sparc64/backoff.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/asm-sparc64/backoff.h
+++ b/include/asm-sparc64/backoff.h
@@ -12,7 +12,8 @@
 	mov	reg, tmp; \
 88:	brnz,pt	tmp, 88b; \
 	 sub	tmp, 1, tmp; \
-	cmp	reg, BACKOFF_LIMIT; \
+	set	BACKOFF_LIMIT, tmp; \
+	cmp	reg, tmp; \
 	bg,pn	%xcc, label; \
 	 nop; \
 	ba,pt	%xcc, label; \

-- 
