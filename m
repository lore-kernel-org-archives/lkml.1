Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112Ab0AZXts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab0AZXts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964Ab0AZXtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:49:20 -0500
Received: from kroah.org ([198.145.64.141]:35470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab0AZXoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:09 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:31 2010
Message-Id: <20100126233930.974004488@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ursula Braun <ursula.braun@de.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, John Jolly <jjolly@suse.de>
Subject: [77/98] netiucv: displayed TX bytes value much too high
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ursula Braun <ursula.braun@de.ibm.com>

commit 998221c26b86a7edd621e66b437628c5ec0f8e9b upstream.

tx_bytes value must be updated by skb length before skb is freed.

Signed-off-by: Ursula Braun <ursula.braun@de.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: John Jolly <jjolly@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/s390/net/netiucv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -741,13 +741,13 @@ static void conn_action_txdone(fsm_insta
 	if (single_flag) {
 		if ((skb = skb_dequeue(&conn->commit_queue))) {
 			atomic_dec(&skb->users);
-			dev_kfree_skb_any(skb);
 			if (privptr) {
 				privptr->stats.tx_packets++;
 				privptr->stats.tx_bytes +=
 					(skb->len - NETIUCV_HDRLEN
-					 	  - NETIUCV_HDRLEN);
+						  - NETIUCV_HDRLEN);
 			}
+			dev_kfree_skb_any(skb);
 		}
 	}
 	conn->tx_buff->data = conn->tx_buff->head;


