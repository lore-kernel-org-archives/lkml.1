Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbZCaXXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbZCaXXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758960AbZCaXUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:25 -0400
Received: from sous-sol.org ([216.99.217.87]:33125 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758938AbZCaXUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:24 -0400
Message-Id: <20090331231403.675724428@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:10:52 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David S Miller <davem@davemloft.net>
Subject: [patch 07/45] xfrm: spin_lock() should be spin_unlock() in xfrm_state.c
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=xfrm-spin_lock-should-be-spin_unlock-in-xfrm_state.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Chuck Ebbert <cebbert@redhat.com>

[ Upstream commit 7d0b591c655ca0d72ebcbd242cf659a20a8995c5 ]

spin_lock() should be spin_unlock() in xfrm_state_walk_done().

caused by:
commit 12a169e7d8f4b1c95252d8b04ed0f1033ed7cfe2
"ipsec: Put dumpers on the dump list"

Reported-by: Marc Milgram <mmilgram@redhat.com>
Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/xfrm/xfrm_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1615,7 +1615,7 @@ void xfrm_state_walk_done(struct xfrm_st
 
 	spin_lock_bh(&xfrm_state_lock);
 	list_del(&walk->all);
-	spin_lock_bh(&xfrm_state_lock);
+	spin_unlock_bh(&xfrm_state_lock);
 }
 EXPORT_SYMBOL(xfrm_state_walk_done);
 

