Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYICRlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYICRlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757230AbYICRkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:40:41 -0400
Received: from ns.suse.de ([195.135.220.2]:52396 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757223AbYICRkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:40:40 -0400
Date: Wed, 3 Sep 2008 10:26:13 -0700
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
       alan@lxorguk.ukuu.org.uk, Jamal Hadi Salim <hadi@cyberus.ca>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 24/42] pkt_sched: Fix actions referencing
Message-ID: <20080903172613.GY7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0005-pkt_sched-Fix-actions-referencing.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jamal Hadi Salim <hadi@cyberus.ca>

[ Upstream commit 76aab2c1eae491a5d73ac83deec97dd28ebac584 ]

When an action is added several times with the same exact index
it gets deleted on every even-numbered attempt.
This fixes that issue.

Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sched/act_api.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -205,10 +205,9 @@ struct tcf_common *tcf_hash_check(u32 in
 {
 	struct tcf_common *p = NULL;
 	if (index && (p = tcf_hash_lookup(index, hinfo)) != NULL) {
-		if (bind) {
+		if (bind)
 			p->tcfc_bindcnt++;
-			p->tcfc_refcnt++;
-		}
+		p->tcfc_refcnt++;
 		a->priv = p;
 	}
 	return p;

-- 
