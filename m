Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbYBBAdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbYBBAdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:33:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763254AbYBBAZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:25:36 -0500
Received: from mx1.suse.de ([195.135.220.2]:54750 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763169AbYBBAZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:25:33 -0500
Date: Fri, 1 Feb 2008 16:21:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com,
       greearb@candelatech.com, divy@chelsio.com,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 25/27] chelsio: Fix skb->dev setting
Message-ID: <20080202002111.GZ8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="chelsio-fix-skb-dev-setting.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Divy Le Ray <divy@chelsio.com>

patch 7de6af0f23b25df8da9719ecae1916b669d0b03d in mainline.

eth_type_trans() now sets skb->dev.
Access skb->def after it gets set.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/chelsio/sge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/chelsio/sge.c
+++ b/drivers/net/chelsio/sge.c
@@ -1378,10 +1378,10 @@ static void sge_rx(struct sge *sge, stru
 	}
 	__skb_pull(skb, sizeof(*p));
 
-	skb->dev->last_rx = jiffies;
 	st = per_cpu_ptr(sge->port_stats[p->iff], smp_processor_id());
 
 	skb->protocol = eth_type_trans(skb, adapter->port[p->iff].dev);
+	skb->dev->last_rx = jiffies;
 	if ((adapter->flags & RX_CSUM_ENABLED) && p->csum == 0xffff &&
 	    skb->protocol == htons(ETH_P_IP) &&
 	    (skb->data[9] == IPPROTO_TCP || skb->data[9] == IPPROTO_UDP)) {

-- 
