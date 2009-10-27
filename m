Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZJ0QcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZJ0QcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbZJ0Qb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:31:59 -0400
Received: from mail-forward1.uio.no ([129.240.10.70]:33107 "EHLO
	mail-forward1.uio.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbZJ0Qb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:31:57 -0400
Message-ID: <4AE72075.4070702@simula.no>
Date: Tue, 27 Oct 2009 17:31:49 +0100
From: Andreas Petlund <apetlund@simula.no>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, shemminger@vyatta.com,
       ilpo.jarvinen@helsinki.fi, davem@davemloft.net
Subject: [PATCH 1/3] net: TCP thin-stream detection
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 10 msgs/h 2 sum rcpts/h 13 sum msgs/h 3 total rcpts 344 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: B001E97BB23B6928B7A4B6E9935994E10BAD8432
X-UiO-SPAM-Test: remote_host: 128.39.37.254 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 3 total 4102 max/h 42 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inline function to dynamically detect thin streams based on the number of packets in flight. Used to trigger thin-stream mechanisms.


Signed-off-by: Andreas Petlund <apetlund@simula.no>
---
 include/net/tcp.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 03a49c7..7c4482f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -800,6 +800,14 @@ static inline bool tcp_in_initial_slowstart(const struct tcp_sock *tp)
 	return tp->snd_ssthresh >= TCP_INFINITE_SSTHRESH;
 }
 
+/* Determines whether this is a thin stream (which may suffer from
+ * increased latency). Used to trigger latency-reducing mechanisms.
+ */
+static inline unsigned int tcp_stream_is_thin(const struct tcp_sock *tp)
+{
+	return tp->packets_out < 4;
+}
+
 /* If cwnd > ssthresh, we may raise ssthresh to be half-way to cwnd.
  * The exception is rate halving phase, when cwnd is decreasing towards
  * ssthresh.
-- 
1.6.0.4


