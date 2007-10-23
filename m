Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbXJWPy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbXJWPy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXJWPyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:54:20 -0400
Received: from flpi185.sbcis.sbc.com ([207.115.20.187]:43686 "EHLO
	flpi185.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbXJWPyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:54:19 -0400
X-ORBL: [76.241.169.38]
From: Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5/5] NET: Remove unneeded implicit type case when calling
	tcp_minshall_update()
To: linux-kernel@vger.kernel.org
Cc: Chuck Lever <chuck.lever@oracle.com>
Date: Tue, 23 Oct 2007 11:44:33 -0400
Message-ID: <20071023154433.28115.72800.stgit@ingres.1015granger.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The tcp_minshall_update() function is called in exactly one place, and is
passed an unsigned integer for the mss_len argument.  Make the sign of the
argument match the sign of the passed variable in order to eliminate an
unneeded implicit type cast and a mixed sign comparison in
tcp_minshall_update().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: <netdev@vger.kernel.org>
---

 include/net/tcp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 92049e6..d695cea 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -803,7 +803,7 @@ static inline int tcp_is_cwnd_limited(const struct sock *sk, u32 in_flight)
 		return left <= tcp_max_burst(tp);
 }
 
-static inline void tcp_minshall_update(struct tcp_sock *tp, int mss,
+static inline void tcp_minshall_update(struct tcp_sock *tp, unsigned int mss,
 				       const struct sk_buff *skb)
 {
 	if (skb->len < mss)

