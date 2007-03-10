Return-Path: <linux-kernel-owner+w=401wt.eu-S1750978AbXCJGV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbXCJGV5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 01:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbXCJGVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 01:21:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbXCJGVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 01:21:13 -0500
Date: Fri, 9 Mar 2007 22:19:08 -0800
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
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 20/20] Fix UDP header pointer after pskb_trim_rcsum()
Message-ID: <20070310061908.GU31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-udp-header-pointer-after-pskb_trim_rcsum.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[UDP]: Reread uh pointer after pskb_trim

The header may have moved when trimming.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/udp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1214,6 +1214,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, 
 
 		if (ulen < sizeof(*uh) || pskb_trim_rcsum(skb, ulen))
 			goto short_packet;
+		uh = skb->h.uh;
 
 		udp4_csum_init(skb, uh);
 

-- 
