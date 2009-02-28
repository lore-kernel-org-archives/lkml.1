Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbZB1FE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbZB1FE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 00:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbZB1FDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 00:03:49 -0500
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:45714 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZB1FDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 00:03:47 -0500
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] bluetooth: add write_lock_bh to __l2cap_chan_link
Date: Sat, 28 Feb 2009 02:02:25 -0300
Message-Id: <1235797347-1816-1-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix race condition

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 net/bluetooth/l2cap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index ca4d3b4..355f375 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -175,12 +175,14 @@ static inline void __l2cap_chan_link(struct l2cap_chan_list *l, struct sock *sk)
 {
 	sock_hold(sk);
 
+	write_lock_bh(&l->lock);
 	if (l->head)
 		l2cap_pi(l->head)->prev_c = sk;
 
 	l2cap_pi(sk)->next_c = l->head;
 	l2cap_pi(sk)->prev_c = NULL;
 	l->head = sk;
+	write_unlock_bh(&l->lock);
 }
 
 static inline void l2cap_chan_unlink(struct l2cap_chan_list *l, struct sock *sk)
-- 
1.6.0.6

