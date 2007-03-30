Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbXC3VLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbXC3VLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbXC3VLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:11:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51491 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbXC3VLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:11:02 -0400
Date: Fri, 30 Mar 2007 14:05:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 18/37] Fix decnet endianness
Message-ID: <20070330210502.GU29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-decnet-endianness.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Al Viro <viro@ftp.linux.org.uk>

[PATCH] FRA_{DST,SRC} are le16 for decnet

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/decnet/dn_rules.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/net/decnet/dn_rules.c
+++ b/net/decnet/dn_rules.c
@@ -151,10 +151,10 @@ static int dn_fib_rule_configure(struct 
 	}
 
 	if (tb[FRA_SRC])
-		r->src = nla_get_u16(tb[FRA_SRC]);
+		r->src = nla_get_le16(tb[FRA_SRC]);
 
 	if (tb[FRA_DST])
-		r->dst = nla_get_u16(tb[FRA_DST]);
+		r->dst = nla_get_le16(tb[FRA_DST]);
 
 	r->src_len = frh->src_len;
 	r->srcmask = dnet_make_mask(r->src_len);
@@ -176,10 +176,10 @@ static int dn_fib_rule_compare(struct fi
 	if (frh->dst_len && (r->dst_len != frh->dst_len))
 		return 0;
 
-	if (tb[FRA_SRC] && (r->src != nla_get_u16(tb[FRA_SRC])))
+	if (tb[FRA_SRC] && (r->src != nla_get_le16(tb[FRA_SRC])))
 		return 0;
 
-	if (tb[FRA_DST] && (r->dst != nla_get_u16(tb[FRA_DST])))
+	if (tb[FRA_DST] && (r->dst != nla_get_le16(tb[FRA_DST])))
 		return 0;
 
 	return 1;
@@ -214,9 +214,9 @@ static int dn_fib_rule_fill(struct fib_r
 	frh->tos = 0;
 
 	if (r->dst_len)
-		NLA_PUT_U16(skb, FRA_DST, r->dst);
+		NLA_PUT_LE16(skb, FRA_DST, r->dst);
 	if (r->src_len)
-		NLA_PUT_U16(skb, FRA_SRC, r->src);
+		NLA_PUT_LE16(skb, FRA_SRC, r->src);
 
 	return 0;
 

-- 
