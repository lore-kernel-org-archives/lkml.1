Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbZFIKR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbZFIKR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759956AbZFIKP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:15:58 -0400
Received: from kroah.org ([198.145.64.141]:59780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760018AbZFIKP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:15:57 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:54 2009
Message-Id: <20090609094054.165034585@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:38:57 -0700
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
       alan@lxorguk.ukuu.org.uk, Florian Westphal <fw@strlen.de>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 09/87] pktgen: do not access flows[] beyond its length
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=pktgen-do-not-access-flows-beyond-its-length.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 5b5f792a6a9a2f9ae812d151ed621f72e99b1725 ]

typo -- pkt_dev->nflows is for stats only, the number of concurrent
flows is stored in cflows.

Reported-By: Vladimir Ivashchenko <hazard@francoudi.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/pktgen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2447,7 +2447,7 @@ static inline void free_SAs(struct pktge
 	if (pkt_dev->cflows) {
 		/* let go of the SAs if we have them */
 		int i = 0;
-		for (;  i < pkt_dev->nflows; i++){
+		for (;  i < pkt_dev->cflows; i++) {
 			struct xfrm_state *x = pkt_dev->flows[i].x;
 			if (x) {
 				xfrm_state_put(x);


