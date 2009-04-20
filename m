Return-Path: <linux-kernel-owner+w=401wt.eu-S1754211AbZDTEe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbZDTEe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 00:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZDTEeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 00:34:13 -0400
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:45654 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbZDTEeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 00:34:10 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Bluetooth: fix many errors and warnings reported by checkpatch.pl
Date: Mon, 20 Apr 2009 01:31:08 -0300
Message-Id: <1240201868-1396-5-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1240201868-1396-4-git-send-email-gustavo@las.ic.unicamp.br>
References: <1240201868-1396-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1240201868-1396-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1240201868-1396-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1240201868-1396-4-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the errors without change the l2cap.o binary

 text    data     bss     dec     hex filename
18059     568       0   18627    48c3 l2cap.o.after
18059     568       0   18627    48c3 l2cap.o.before

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 net/bluetooth/l2cap.c |   70 ++++++++++++++++++++++++++++++-------------------
 1 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index a2cc770..76190f0 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -40,10 +40,10 @@
 #include <linux/skbuff.h>
 #include <linux/list.h>
 #include <linux/device.h>
+#include <linux/uaccess.h>
 #include <net/sock.h>
 
 #include <asm/system.h>
-#include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
 #include <net/bluetooth/bluetooth.h>
@@ -134,7 +134,8 @@ static inline struct sock *l2cap_get_chan_by_scid(struct l2cap_chan_list *l, u16
 	struct sock *s;
 	read_lock(&l->lock);
 	s = __l2cap_get_chan_by_scid(l, cid);
-	if (s) bh_lock_sock(s);
+	if (s)
+		bh_lock_sock(s);
 	read_unlock(&l->lock);
 	return s;
 }
@@ -154,7 +155,8 @@ static inline struct sock *l2cap_get_chan_by_ident(struct l2cap_chan_list *l, u8
 	struct sock *s;
 	read_lock(&l->lock);
 	s = __l2cap_get_chan_by_ident(l, ident);
-	if (s) bh_lock_sock(s);
+	if (s)
+		bh_lock_sock(s);
 	read_unlock(&l->lock);
 	return s;
 }
@@ -164,7 +166,7 @@ static u16 l2cap_alloc_cid(struct l2cap_chan_list *l)
 	u16 cid = L2CAP_CID_DYN_START;
 
 	for (; cid < L2CAP_CID_DYN_END; cid++) {
-		if(!__l2cap_get_chan_by_scid(l, cid))
+		if (!__l2cap_get_chan_by_scid(l, cid))
 			return cid;
 	}
 
@@ -204,7 +206,8 @@ static void __l2cap_chan_add(struct l2cap_conn *conn, struct sock *sk, struct so
 {
 	struct l2cap_chan_list *l = &conn->chan_list;
 
-	BT_DBG("conn %p, psm 0x%2.2x, dcid 0x%4.4x", conn, l2cap_pi(sk)->psm, l2cap_pi(sk)->dcid);
+	BT_DBG("conn %p, psm 0x%2.2x, dcid 0x%4.4x", conn,
+			l2cap_pi(sk)->psm, l2cap_pi(sk)->dcid);
 
 	conn->disc_reason = 0x13;
 
@@ -272,7 +275,7 @@ static inline int l2cap_check_security(struct sock *sk)
 		if (l2cap_pi(sk)->sec_level == BT_SECURITY_HIGH)
 			auth_type = HCI_AT_NO_BONDING_MITM;
 		else
-                        auth_type = HCI_AT_NO_BONDING;
+			auth_type = HCI_AT_NO_BONDING;
 
 		if (l2cap_pi(sk)->sec_level == BT_SECURITY_LOW)
 			l2cap_pi(sk)->sec_level = BT_SECURITY_SDP;
@@ -588,7 +591,8 @@ static inline struct sock *l2cap_get_sock_by_psm(int state, __le16 psm, bdaddr_t
 	struct sock *s;
 	read_lock(&l2cap_sk_list.lock);
 	s = __l2cap_get_sock_by_psm(state, psm, src);
-	if (s) bh_lock_sock(s);
+	if (s)
+		bh_lock_sock(s);
 	read_unlock(&l2cap_sk_list.lock);
 	return s;
 }
@@ -849,7 +853,8 @@ static int l2cap_do_connect(struct sock *sk)
 	BT_DBG("%s -> %s psm 0x%2.2x", batostr(src), batostr(dst),
 							l2cap_pi(sk)->psm);
 
-	if (!(hdev = hci_get_route(dst, src)))
+	hdev = hci_get_route(dst, src);
+	if (!hdev)
 		return -EHOSTUNREACH;
 
 	hci_dev_lock_bh(hdev);
@@ -948,7 +953,7 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr, int al
 		goto done;
 	}
 
-	switch(sk->sk_state) {
+	switch (sk->sk_state) {
 	case BT_CONNECT:
 	case BT_CONNECT2:
 	case BT_CONFIG:
@@ -973,7 +978,8 @@ static int l2cap_sock_connect(struct socket *sock, struct sockaddr *addr, int al
 	bacpy(&bt_sk(sk)->dst, &la.l2_bdaddr);
 	l2cap_pi(sk)->psm = la.l2_psm;
 
-	if ((err = l2cap_do_connect(sk)))
+	err = l2cap_do_connect(sk);
+	if (err)
 		goto done;
 
 wait:
@@ -1112,7 +1118,7 @@ static inline int l2cap_do_send(struct sock *sk, struct msghdr *msg, int len)
 {
 	struct l2cap_conn *conn = l2cap_pi(sk)->conn;
 	struct sk_buff *skb, **frag;
-	int err, hlen, count, sent=0;
+	int err, hlen, count, sent = 0;
 	struct l2cap_hdr *lh;
 
 	BT_DBG("sk %p len %d", sk, len);
@@ -1165,8 +1171,8 @@ static inline int l2cap_do_send(struct sock *sk, struct msghdr *msg, int len)
 
 		frag = &(*frag)->next;
 	}
-
-	if ((err = hci_send_acl(conn->hcon, skb, 0)) < 0)
+	err = hci_send_acl(conn->hcon, skb, 0);
+	if (err < 0)
 		goto fail;
 
 	return sent;
@@ -1554,7 +1560,7 @@ static void l2cap_raw_recv(struct l2cap_conn *conn, struct sk_buff *skb)
 {
 	struct l2cap_chan_list *l = &conn->chan_list;
 	struct sk_buff *nskb;
-	struct sock * sk;
+	struct sock *sk;
 
 	BT_DBG("conn %p", conn);
 
@@ -1566,8 +1572,8 @@ static void l2cap_raw_recv(struct l2cap_conn *conn, struct sk_buff *skb)
 		/* Don't send frame to the socket it came from */
 		if (skb->sk == sk)
 			continue;
-
-		if (!(nskb = skb_clone(skb, GFP_ATOMIC)))
+		nskb = skb_clone(skb, GFP_ATOMIC);
+		if (!nskb)
 			continue;
 
 		if (sock_queue_rcv_skb(sk, nskb))
@@ -1585,7 +1591,8 @@ static struct sk_buff *l2cap_build_cmd(struct l2cap_conn *conn,
 	struct l2cap_hdr *lh;
 	int len, count;
 
-	BT_DBG("conn %p, code 0x%2.2x, ident 0x%2.2x, len %d", conn, code, ident, dlen);
+	BT_DBG("conn %p, code 0x%2.2x, ident 0x%2.2x, len %d",
+			conn, code, ident, dlen);
 
 	len = L2CAP_HDR_SIZE + L2CAP_CMD_HDR_SIZE + dlen;
 	count = min_t(unsigned int, conn->mtu, len);
@@ -1964,10 +1971,12 @@ static inline int l2cap_connect_rsp(struct l2cap_conn *conn, struct l2cap_cmd_hd
 	BT_DBG("dcid 0x%4.4x scid 0x%4.4x result 0x%2.2x status 0x%2.2x", dcid, scid, result, status);
 
 	if (scid) {
-		if (!(sk = l2cap_get_chan_by_scid(&conn->chan_list, scid)))
+		sk = l2cap_get_chan_by_scid(&conn->chan_list, scid);
+		if (!sk)
 			return 0;
 	} else {
-		if (!(sk = l2cap_get_chan_by_ident(&conn->chan_list, cmd->ident)))
+		sk = l2cap_get_chan_by_ident(&conn->chan_list, cmd->ident);
+		if (!sk)
 			return 0;
 	}
 
@@ -2010,7 +2019,8 @@ static inline int l2cap_config_req(struct l2cap_conn *conn, struct l2cap_cmd_hdr
 
 	BT_DBG("dcid 0x%4.4x flags 0x%2.2x", dcid, flags);
 
-	if (!(sk = l2cap_get_chan_by_scid(&conn->chan_list, dcid)))
+	sk = l2cap_get_chan_by_scid(&conn->chan_list, dcid);
+	if (!sk)
 		return -ENOENT;
 
 	if (sk->sk_state == BT_DISCONN)
@@ -2077,9 +2087,11 @@ static inline int l2cap_config_rsp(struct l2cap_conn *conn, struct l2cap_cmd_hdr
 	flags  = __le16_to_cpu(rsp->flags);
 	result = __le16_to_cpu(rsp->result);
 
-	BT_DBG("scid 0x%4.4x flags 0x%2.2x result 0x%2.2x", scid, flags, result);
+	BT_DBG("scid 0x%4.4x flags 0x%2.2x result 0x%2.2x",
+			scid, flags, result);
 
-	if (!(sk = l2cap_get_chan_by_scid(&conn->chan_list, scid)))
+	sk = l2cap_get_chan_by_scid(&conn->chan_list, scid);
+	if (!sk)
 		return 0;
 
 	switch (result) {
@@ -2140,7 +2152,8 @@ static inline int l2cap_disconnect_req(struct l2cap_conn *conn, struct l2cap_cmd
 
 	BT_DBG("scid 0x%4.4x dcid 0x%4.4x", scid, dcid);
 
-	if (!(sk = l2cap_get_chan_by_scid(&conn->chan_list, dcid)))
+	sk = l2cap_get_chan_by_scid(&conn->chan_list, dcid);
+	if (!sk)
 		return 0;
 
 	rsp.dcid = cpu_to_le16(l2cap_pi(sk)->scid);
@@ -2167,7 +2180,8 @@ static inline int l2cap_disconnect_rsp(struct l2cap_conn *conn, struct l2cap_cmd
 
 	BT_DBG("dcid 0x%4.4x scid 0x%4.4x", dcid, scid);
 
-	if (!(sk = l2cap_get_chan_by_scid(&conn->chan_list, scid)))
+	sk = l2cap_get_chan_by_scid(&conn->chan_list, scid);
+	if (!sk)
 		return 0;
 
 	l2cap_chan_del(sk, 0);
@@ -2401,7 +2415,8 @@ drop:
 	kfree_skb(skb);
 
 done:
-	if (sk) bh_unlock_sock(sk);
+	if (sk)
+		bh_unlock_sock(sk);
 	return 0;
 }
 
@@ -2648,7 +2663,8 @@ static int l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 fl
 		}
 
 		/* Allocate skb for the complete frame (with header) */
-		if (!(conn->rx_skb = bt_skb_alloc(len, GFP_ATOMIC)))
+		conn->rx_skb = bt_skb_alloc(len, GFP_ATOMIC);
+		if (!conn->rx_skb)
 			goto drop;
 
 		skb_copy_from_linear_data(skb, skb_put(conn->rx_skb, skb->len),
@@ -2708,7 +2724,7 @@ static ssize_t l2cap_sysfs_show(struct class *dev, char *buf)
 
 	read_unlock_bh(&l2cap_sk_list.lock);
 
-	return (str - buf);
+	return str - buf;
 }
 
 static CLASS_ATTR(l2cap, S_IRUGO, l2cap_sysfs_show, NULL);
-- 
1.6.0.6

