Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYFGBXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYFGBXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbYFGBJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:45 -0400
Received: from sous-sol.org ([216.99.217.87]:42545 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760227AbYFGBJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:27 -0400
Message-Id: <20080607010626.752571721@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:52 -0700
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
       Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
       davem@davemloft.net, Alexey Dobriyan <adobriyan@parallels.com>
Subject: [patch 37/50] netfilter: nf_conntrack_expect: fix error path unwind in nf_conntrack_expect_init()
Content-Disposition: inline; filename=netfilter-nf_conntrack_expect-fix-error-path-unwind-in-nf_conntrack_expect_init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Patrick McHardy <kaber@trash.net>

upstream commit: 12293bf91126ad253a25e2840b307fdc7c2754c3

Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 net/netfilter/nf_conntrack_expect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -550,10 +550,10 @@ int __init nf_conntrack_expect_init(void
 	return 0;
 
 err3:
+	kmem_cache_destroy(nf_ct_expect_cachep);
+err2:
 	nf_ct_free_hashtable(nf_ct_expect_hash, nf_ct_expect_vmalloc,
 			     nf_ct_expect_hsize);
-err2:
-	kmem_cache_destroy(nf_ct_expect_cachep);
 err1:
 	return err;
 }

-- 
