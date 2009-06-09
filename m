Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbZFIKRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbZFIKRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760069AbZFIKQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:16:03 -0400
Received: from kroah.org ([198.145.64.141]:59792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760050AbZFIKQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:16:00 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:54 2009
Message-Id: <20090609094054.391134475@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:38:58 -0700
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
       alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 10/87] myr10ge: again fix lro_gen_skb() alignment
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=myr10ge-again-fix-lro_gen_skb-alignment.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

[ Upstream commit 636d2f68a0814d84de26c021b2c15e3b4ffa29de ]

Add LRO alignment initially committed in
621544eb8c3beaa859c75850f816dd9b056a00a3 ("[LRO]: fix lro_gen_skb()
alignment") and removed in 0dcffac1a329be69bab0ac604bf7283737108e68
("myri10ge: add multislices support") during conversion to
multi-slice.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/myri10ge/myri10ge.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/myri10ge/myri10ge.c
+++ b/drivers/net/myri10ge/myri10ge.c
@@ -2446,6 +2446,7 @@ static int myri10ge_open(struct net_devi
 		lro_mgr->lro_arr = ss->rx_done.lro_desc;
 		lro_mgr->get_frag_header = myri10ge_get_frag_header;
 		lro_mgr->max_aggr = myri10ge_lro_max_pkts;
+		lro_mgr->frag_align_pad = 2;
 		if (lro_mgr->max_aggr > MAX_SKB_FRAGS)
 			lro_mgr->max_aggr = MAX_SKB_FRAGS;
 


