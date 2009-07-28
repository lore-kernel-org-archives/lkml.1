Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbZG1Xv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbZG1Xv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbZG1Xuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:35 -0400
Received: from kroah.org ([198.145.64.141]:35958 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbZG1Xu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:42:01 2009
Message-Id: <20090728234201.082668312@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>
Subject: [patch 62/71] netfilter: xt_rateest: fix comparison with self
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=netfilter-xt_rateest-fix-comparison-with-self.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit 4d900f9df5f0569c2dc536701e2c11b6d50ebebf upstream.

As noticed by Török Edwin <edwintorok@gmail.com>:

Compiling the kernel with clang has shown this warning:

net/netfilter/xt_rateest.c:69:16: warning: self-comparison always results in a
constant value
                        ret &= pps2 == pps2;
                                    ^
Looking at the code:
if (info->flags & XT_RATEEST_MATCH_BPS)
            ret &= bps1 == bps2;
        if (info->flags & XT_RATEEST_MATCH_PPS)
            ret &= pps2 == pps2;

Judging from the MATCH_BPS case it seems to be a typo, with the intention of
comparing pps1 with pps2.

http://bugzilla.kernel.org/show_bug.cgi?id=13535

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/xt_rateest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -66,7 +66,7 @@ xt_rateest_mt(const struct sk_buff *skb,
 		if (info->flags & XT_RATEEST_MATCH_BPS)
 			ret &= bps1 == bps2;
 		if (info->flags & XT_RATEEST_MATCH_PPS)
-			ret &= pps2 == pps2;
+			ret &= pps1 == pps2;
 		break;
 	}
 


