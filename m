Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbZAaFwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbZAaFwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 00:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZAaFwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 00:52:05 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:36442 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZAaFwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 00:52:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Xtq3DkOmF0SEYTRGFk1yXKzYPK9zACeAaTfWl+jusG6GWW7nGjrGTkX17fUoX5itMO
         tU/k5N0HknyActsj7ZlwTvptoKHzIkDtwh/bSmudApVq0SwswTSPBD/Ra3SE2g51/t+9
         N9JHD56QQv67EKfLeAYx/lZOtUit8nVx1stNs=
Message-ID: <4983E6D3.6010409@gmail.com>
Date: Sat, 31 Jan 2009 13:51:15 +0800
From: Dave Young <hidave.darkstar@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081010)
MIME-Version: 1.0
To: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       marcel@holtmann.org, davem@davemloft.net
Subject: [PATCH] bluetooth: CONFIG_DEBUG_LOCK_ALLOC ifdefs remove
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Due to lockdep changes the CONFIG_DEBUG_LOCK_ALLOC ifdef is not needed now, just remove it here.

The following commit fixed the !lockdep build warnings:

commit e8f6fbf62de37cbc2e179176ac7010d5f4396b67
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Nov 12 01:38:36 2008 +0000

    lockdep: include/linux/lockdep.h - fix warning in net/bluetooth/af_bluetooth.c

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
net/bluetooth/af_bluetooth.c |    6 ------
1 file changed, 6 deletions(-)

diff -uprN a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
--- a/net/bluetooth/af_bluetooth.c	2009-01-31 13:38:45.000000000 +0800
+++ b/net/bluetooth/af_bluetooth.c	2009-01-31 13:38:58.000000000 +0800
@@ -48,7 +48,6 @@
 static struct net_proto_family *bt_proto[BT_MAX_PROTO];
 static DEFINE_RWLOCK(bt_proto_lock);
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key bt_lock_key[BT_MAX_PROTO];
 static const char *bt_key_strings[BT_MAX_PROTO] = {
 	"sk_lock-AF_BLUETOOTH-BTPROTO_L2CAP",
@@ -86,11 +85,6 @@ static inline void bt_sock_reclassify_lo
 			bt_slock_key_strings[proto], &bt_slock_key[proto],
 				bt_key_strings[proto], &bt_lock_key[proto]);
 }
-#else
-static inline void bt_sock_reclassify_lock(struct socket *sock, int proto)
-{
-}
-#endif
 
 int bt_sock_register(int proto, struct net_proto_family *ops)
 {
