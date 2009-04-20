Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZDTEfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZDTEfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 00:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZDTEeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 00:34:21 -0400
Received: from everest.las.ic.unicamp.br ([143.106.60.118]:45655 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbZDTEeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 00:34:20 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Bluetooth: create macro to hint mask on receiving config request
Date: Mon, 20 Apr 2009 01:31:07 -0300
Message-Id: <1240201868-1396-4-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1240201868-1396-3-git-send-email-gustavo@las.ic.unicamp.br>
References: <1240201868-1396-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1240201868-1396-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1240201868-1396-3-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L2CAP_CONF_HINT is better to understand than 0x80. And we don't need to
go to spec to figure out what 0x80 is.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 include/net/bluetooth/l2cap.h |    2 ++
 net/bluetooth/l2cap.c         |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index ed4ba91..300b63f 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -149,6 +149,8 @@ struct l2cap_conf_opt {
 } __attribute__ ((packed));
 #define L2CAP_CONF_OPT_SIZE	2
 
+#define L2CAP_CONF_HINT		0x80
+
 #define L2CAP_CONF_MTU		0x01
 #define L2CAP_CONF_FLUSH_TO	0x02
 #define L2CAP_CONF_QOS		0x03
diff --git a/net/bluetooth/l2cap.c b/net/bluetooth/l2cap.c
index 85926f5..a2cc770 100644
--- a/net/bluetooth/l2cap.c
+++ b/net/bluetooth/l2cap.c
@@ -1737,7 +1737,7 @@ static int l2cap_parse_conf_req(struct sock *sk, void *data)
 	while (len >= L2CAP_CONF_OPT_SIZE) {
 		len -= l2cap_get_conf_opt(&req, &type, &olen, &val);
 
-		hint  = type & 0x80;
+		hint  = type & L2CAP_CONF_HINT;
 		type &= 0x7f;
 
 		switch (type) {
-- 
1.6.0.6

