Return-Path: <linux-kernel-owner+w=401wt.eu-S1764827AbZD3RJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764827AbZD3RJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764283AbZD3RHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:07:21 -0400
Received: from kroah.org ([198.145.64.141]:56151 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762241AbZD3RHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:16 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:39 2009
Message-Id: <20090430165739.242208431@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:55:55 -0700
From: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 06/88] xfrm: spin_lock() should be spin_unlock() in xfrm_state.c
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=xfrm-spin_lock-should-be-spin_unlock-in-xfrm_state.c.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chuck Ebbert <cebbert@redhat.com>

[ Upstream commit 7d0b591c655ca0d72ebcbd242cf659a20a8995c5 ]

spin_lock() should be spin_unlock() in xfrm_state_walk_done().

caused by:
commit 12a169e7d8f4b1c95252d8b04ed0f1033ed7cfe2
"ipsec: Put dumpers on the dump list"

Reported-by: Marc Milgram <mmilgram@redhat.com>
Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 net/xfrm/xfrm_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1601,7 +1601,7 @@ void xfrm_state_walk_done(struct xfrm_st
 
 	spin_lock_bh(&xfrm_state_lock);
 	list_del(&walk->all);
-	spin_lock_bh(&xfrm_state_lock);
+	spin_unlock_bh(&xfrm_state_lock);
 }
 EXPORT_SYMBOL(xfrm_state_walk_done);
 


