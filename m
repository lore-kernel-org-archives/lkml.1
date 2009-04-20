Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZDTEel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZDTEel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 00:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZDTEeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 00:34:09 -0400
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:45654 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbZDTEeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 00:34:08 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Bluetooth: remove unnecessary atribution to err var
Date: Mon, 20 Apr 2009 01:31:06 -0300
Message-Id: <1240201868-1396-3-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1240201868-1396-2-git-send-email-gustavo@las.ic.unicamp.br>
References: <1240201868-1396-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1240201868-1396-2-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The init value of err is not used until it is set to -ENOMEM. So we
initialize it directly to -ENOMEM

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 net/bluetooth/l2cap.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index ff1744e..85926f5 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -844,7 +844,7 @@ static int l2cap_do_connect(struct sock *sk)
 	struct hci_conn *hcon;
 	struct hci_dev *hdev;
 	__u8 auth_type;
-	int err = 0;
+	int err = -ENOMEM;
 
 	BT_DBG("%s -> %s psm 0x%2.2x", batostr(src), batostr(dst),
 							l2cap_pi(sk)->psm);
@@ -854,8 +854,6 @@ static int l2cap_do_connect(struct sock *sk)
 
 	hci_dev_lock_bh(hdev);
 
-	err = -ENOMEM;
-
 	if (sk->sk_type == SOCK_RAW) {
 		switch (l2cap_pi(sk)->sec_level) {
 		case BT_SECURITY_HIGH:
-- 
1.6.0.6

