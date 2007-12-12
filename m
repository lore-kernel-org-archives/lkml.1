Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbXLLUfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbXLLUfD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:35:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbXLLUev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:34:51 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:3405 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbXLLUeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:34:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RfFOZU/z3o8GHSaQQo36IcdG6lOt6/Ryo1nULHQlZ9IknOc9Ay66euPg5j05V++pETsGR2Rdb9AKGbp+owTNd6wBlx3NxEC3+8GeV+AufxEyXSrIzRfCRrjL7eTBwXa/JZuTBRSCdXa9ij1tBR77Y3JO1sH5x4E+NVxnNtZZFP4=
Subject: [PATCH] net: remove fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>
To: linux-netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 12:34:49 -0800
Message-Id: <1197491689.21291.16.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fastcall is always empty, remove it from net/

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/bluetooth/rfcomm/core.c |    4 ++--
 net/core/dev.c              |    2 +-
 net/core/sock.c             |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index e7ac6ba..fc98883 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -467,7 +467,7 @@ int rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb)
 	return len;
 }
 
-void fastcall __rfcomm_dlc_throttle(struct rfcomm_dlc *d)
+void __rfcomm_dlc_throttle(struct rfcomm_dlc *d)
 {
 	BT_DBG("dlc %p state %ld", d, d->state);
 
@@ -478,7 +478,7 @@ void fastcall __rfcomm_dlc_throttle(struct rfcomm_dlc *d)
 	rfcomm_schedule(RFCOMM_SCHED_TX);
 }
 
-void fastcall __rfcomm_dlc_unthrottle(struct rfcomm_dlc *d)
+void __rfcomm_dlc_unthrottle(struct rfcomm_dlc *d)
 {
 	BT_DBG("dlc %p state %ld", d, d->state);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 86d6261..acf71ba 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2138,7 +2138,7 @@ static int process_backlog(struct napi_struct *napi, int quota)
  *
  * The entry's receive function will be scheduled to run
  */
-void fastcall __napi_schedule(struct napi_struct *n)
+void __napi_schedule(struct napi_struct *n)
 {
 	unsigned long flags;
 
diff --git a/net/core/sock.c b/net/core/sock.c
index c519b43..c536149 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1613,7 +1613,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	atomic_set(&sk->sk_refcnt, 1);
 }
 
-void fastcall lock_sock_nested(struct sock *sk, int subclass)
+void lock_sock_nested(struct sock *sk, int subclass)
 {
 	might_sleep();
 	spin_lock_bh(&sk->sk_lock.slock);
@@ -1630,7 +1630,7 @@ void fastcall lock_sock_nested(struct sock *sk, int subclass)
 
 EXPORT_SYMBOL(lock_sock_nested);
 
-void fastcall release_sock(struct sock *sk)
+void release_sock(struct sock *sk)
 {
 	/*
 	 * The sk_lock has mutex_unlock() semantics:
-- 
1.5.3.7.2212.gd092



