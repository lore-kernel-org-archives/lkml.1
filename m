Return-Path: <linux-kernel-owner+w=401wt.eu-S1765515AbXGSXRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765515AbXGSXRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXGSXRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:17:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48019 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbXGSXRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:17:48 -0400
Date: Fri, 20 Jul 2007 00:17:45 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: [PATCH] missed cong_avoid() instance
Message-ID: <20070719231745.GW21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Removal of rtt argument in ->cong_avoid() had missed tcp_htcp.c
instance.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/net/ipv4/tcp_htcp.c b/net/ipv4/tcp_htcp.c
index 632c05a..08a02e6 100644
--- a/net/ipv4/tcp_htcp.c
+++ b/net/ipv4/tcp_htcp.c
@@ -225,7 +225,7 @@ static u32 htcp_recalc_ssthresh(struct sock *sk)
 	return max((tp->snd_cwnd * ca->beta) >> 7, 2U);
 }
 
-static void htcp_cong_avoid(struct sock *sk, u32 ack, s32 rtt,
+static void htcp_cong_avoid(struct sock *sk, u32 ack,
 			    u32 in_flight, int data_acked)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
