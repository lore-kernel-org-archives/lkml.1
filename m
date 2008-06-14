Return-Path: <linux-kernel-owner+w=401wt.eu-S1762727AbYFNAQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762727AbYFNAQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760858AbYFNANM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:13:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:51729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760186AbYFNANK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:13:10 -0400
Date: Fri, 13 Jun 2008 17:10:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Kazunori MIYAZAWA <kazunori@miyazawa.org>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 14/47] af_key: Fix selector family initialization.
Message-ID: <20080614001052.GN24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="af_key-fix-selector-family-initialization.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kazunori MIYAZAWA <kazunori@miyazawa.org>

[ upstream commit: 4da5105687e0993a3bbdcffd89b2b94d9377faab ]

This propagates the xfrm_user fix made in commit
bcf0dda8d2408fe1c1040cdec5a98e5fcad2ac72 ("[XFRM]: xfrm_user: fix
selector family initialization")

Based upon a bug report from, and tested by, Alan Swanson.

Signed-off-by: Kazunori MIYAZAWA <kazunori@miyazawa.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/key/af_key.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1219,7 +1219,7 @@ static struct xfrm_state * pfkey_msg2xfr
 		x->sel.prefixlen_s = addr->sadb_address_prefixlen;
 	}
 
-	if (x->props.mode == XFRM_MODE_TRANSPORT)
+	if (!x->sel.family)
 		x->sel.family = x->props.family;
 
 	if (ext_hdrs[SADB_X_EXT_NAT_T_TYPE-1]) {

-- 
