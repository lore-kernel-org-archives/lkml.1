Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760033AbYLQAHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbYLQAHk (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759322AbYLQAGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:06:00 -0500
Received: from kroah.org ([198.145.64.141]:41273 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759656AbYLQAF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:05:59 -0500
Date: Tue, 16 Dec 2008 16:04:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Hartkopp <oliver@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 09/22] can: omit received RTR frames for single ID filter
	lists
Message-ID: <20081217000417.GJ4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="can-omit-received-rtr-frames-for-single-id-filter-lists.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Hartkopp <oliver@hartkopp.net>

commit f706644d55f90e8306d87060168fef33804d6dd9 upstream.

Since commit d253eee20195b25e298bf162a6e72f14bf4803e5 the single CAN
identifier filter lists handle only non-RTR CAN frames.

So we need to omit the check of these filter lists when receiving RTR
CAN frames.

Signed-off-by: Oliver Hartkopp <oliver@hartkopp.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/can/af_can.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -622,7 +622,10 @@ static int can_rcv_filter(struct dev_rcv
 		}
 	}
 
-	/* check CAN_ID specific entries */
+	/* check filterlists for single non-RTR can_ids */
+	if (can_id & CAN_RTR_FLAG)
+		return matches;
+
 	if (can_id & CAN_EFF_FLAG) {
 		hlist_for_each_entry_rcu(r, n, &d->rx[RX_EFF], list) {
 			if (r->can_id == can_id) {

