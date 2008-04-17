Return-Path: <linux-kernel-owner+w=401wt.eu-S1762685AbYDQBKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762685AbYDQBKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbYDQBHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:09 -0400
Received: from sous-sol.org ([216.99.217.87]:58797 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbYDQBHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:04 -0400
Message-Id: <20080417010342.035097178@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:54 -0700
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
       Patrick McHardy <kaber@trash.net>, David S Miller <davem@davemloft.net>
Subject: LLC: Restrict LLC sockets to root
Content-Disposition: inline; filename=llc-restrict-llc-sockets-to-root.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Patrick McHardy <kaber@trash.net>

Upstream commit: 3480c63bdf008e9289aab94418f43b9592978fff

LLC currently allows users to inject raw frames, including IP packets
encapsulated in SNAP. While Linux doesn't handle IP over SNAP, other
systems do. Restrict LLC sockets to root similar to packet sockets.

[ Modified Patrick's patch to use CAP_NEW_RAW --DaveM ]

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/llc/af_llc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -155,6 +155,9 @@ static int llc_ui_create(struct net *net
 	struct sock *sk;
 	int rc = -ESOCKTNOSUPPORT;
 
+	if (!capable(CAP_NET_RAW))
+		return -EPERM;
+
 	if (net != &init_net)
 		return -EAFNOSUPPORT;
 

-- 
