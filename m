Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab0BHPEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 10:04:41 -0500
Received: from mail-forward2.uio.no ([129.240.10.71]:46022 "EHLO
	mail-forward2.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab0BHPEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 10:04:40 -0500
X-Greylist: delayed 2155 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Feb 2010 10:04:40 EST
Message-ID: <4B701EDC.7040109@simula.no>
Date: Mon, 08 Feb 2010 15:25:32 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>, william.allen.simpson@gmail.com
Subject: [net-next PATCH v2 1/3] net: TCP thin-stream detection
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 16 msgs/h 2 sum rcpts/h 16 sum msgs/h 2 total rcpts 733 max rcpts/h 37 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 07904D0FFB1A361AD0502B16E68818F68BD43845
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 13 total 18727 max/h 66 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Major change: Stopped stream from being detected as thin if in initial slow-start

>From 1c448f7c65a016ded7eedd44fe74874e5b3cdbc0 Mon Sep 17 00:00:00 2001
From: Andreas Petlund <apetlund@simula.no>
Date: Mon, 8 Feb 2010 14:05:24 +0100
Subject: [PATCH 1/3] net: TCP thin-stream detection


Signed-off-by: Andreas Petlund <apetlund@simula.no>
---
 include/net/tcp.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 87d164b..e5e2056 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1386,6 +1386,13 @@ static inline void tcp_highest_sack_combine(struct sock *sk,
 		tcp_sk(sk)->highest_sack = new;
 }
 
+/* Determines whether this is a thin stream (which may suffer from
+ * increased latency). Used to trigger latency-reducing mechanisms.*/
+static inline unsigned int tcp_stream_is_thin(struct tcp_sock *tp)
+{
+	return tp->packets_out < 4 && !tcp_in_initial_slowstart(tp);
+}
+
 /* /proc */
 enum tcp_seq_states {
 	TCP_SEQ_STATE_LISTENING,
-- 
1.6.3.3



