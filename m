Return-Path: <linux-kernel-owner+w=401wt.eu-S1764731AbXLMHQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764731AbXLMHQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762668AbXLMG6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:58:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55631 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762661AbXLMG6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:58:17 -0500
Date: Wed, 12 Dec 2007 22:53:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, bunk@kernel.org,
       davem@davemloft.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joonwoo Park <joonwpark81@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [patch 50/60] VLAN: Fix nested VLAN transmit bug
Message-ID: <20071213065325.GZ6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vlan-fix-nested-vlan-transmit-bug.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Joonwoo Park <joonwpark81@gmail.com>

[VLAN]: Fix nested VLAN transmit bug

[ Upstream commit: 6ab3b487db77fa98a24560f11a5a8e744b98d877 ]

Fix misbehavior of vlan_dev_hard_start_xmit() for recursive encapsulations.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/8021q/vlan_dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -459,7 +459,8 @@ int vlan_dev_hard_start_xmit(struct sk_b
 	 * OTHER THINGS LIKE FDDI/TokenRing/802.3 SNAPs...
 	 */
 
-	if (veth->h_vlan_proto != htons(ETH_P_8021Q)) {
+	if (veth->h_vlan_proto != htons(ETH_P_8021Q) ||
+		VLAN_DEV_INFO(dev)->flags & VLAN_FLAG_REORDER_HDR) {
 		int orig_headroom = skb_headroom(skb);
 		unsigned short veth_TCI;
 

-- 
