Return-Path: <linux-kernel-owner+w=401wt.eu-S1765601AbYEBImL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765601AbYEBImL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 04:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758479AbYEBIl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 04:41:57 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:48601 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbYEBIl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 04:41:57 -0400
MIME-Version: 1.0
Date: Fri, 02 May 2008 10:41:53 +0200
From: <oliver@zipernowsky.hu>
To: John Heffner <jheffner@napa>
Cc: John Heffner <jheffner@napa (none)>, linux-kernel@vger.kernel.org
Subject: increase-the-max_burst-threshold-from-3-to-tp-reordering.patch added to
 queue-2.6.22.23-op1
Reply-To: oliver.pntr@gmail.com
Message-ID: <3b97f803bdd1adc618bb53aae1316043@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your patch added to queue-2.6.22.23-op1.
If anyone has any objections, please let us know.

http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
git://repo.or.cz/linux-2.6.22.y-op-patches.git

---

>From 3c0390e1a6d8a5d0cdae57959f0be37a236b474d Mon Sep 17 00:00:00 2001
From: John Heffner <jheffner@napa.(none)>
Date: Fri, 25 Apr 2008 01:43:57 -0700
Subject: [PATCH] [TCP]: Increase the max_burst threshold from 3 to
tp->reordering.

From: John Heffner <jheffner@napa.(none)>

[ Upstream commit: dd9e0dda66ba38a2ddd1405ac279894260dc5c36 ]

This change is necessary to allow cwnd to grow during persistent
reordering.  Cwnd moderation is applied when in the disorder state
and an ack that fills the hole comes in.  If the hole was greater
than 3 packets, but less than tp->reordering, cwnd will shrink when
it should not have.

Signed-off-by: John Heffner <jheffner@napa.(none)>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/tcp.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -775,11 +775,14 @@ extern void tcp_enter_cwr(struct sock *s
 extern __u32 tcp_init_cwnd(struct tcp_sock *tp, struct dst_entry *dst);
 
 /* Slow start with delack produces 3 packets of burst, so that
- * it is safe "de facto".
+ * it is safe "de facto".  This will be the default - same as
+ * the default reordering threshold - but if reordering increases,
+ * we must be able to allow cwnd to burst at least this much in order
+ * to not pull it back when holes are filled.
  */
 static __inline__ __u32 tcp_max_burst(const struct tcp_sock *tp)
 {
-	return 3;
+	return tp->reordering;
 }
 
 /* RFC2861 Check whether we are limited by application or congestion
window


