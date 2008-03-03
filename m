Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYCCNWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYCCNWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 08:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYCCNWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 08:22:38 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:56204 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544AbYCCNWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 08:22:38 -0500
Date: Mon, 03 Mar 2008 14:23:38 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Subject: [PATCH] Removing unneeded statement from tcp_ipv4.c
To: netdev@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <47CBFBDA.7000801@nets.rwth-aachen.de>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Content-transfer-encoding: 7BIT
X-IronPort-AV: E=Sophos;i="4.25,438,1199660400";   d="scan'208";a="53597868"
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid setting tstamp_ok because this is done two lines later anyway.

Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 00156bf..a28c4c2 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1302,15 +1302,14 @@ int tcp_v4_conn_request(struct sock *sk, struct sk_buff *skb)
                tmp_opt.saw_tstamp = 0;
        }

-       if (tmp_opt.saw_tstamp && !tmp_opt.rcv_tsval) {
+       if (tmp_opt.saw_tstamp && !tmp_opt.rcv_tsval)
                /* Some OSes (unknown ones, but I see them on web server, which
                 * contains information interesting only for windows'
                 * users) do not send their stamp in SYN. It is easy case.
                 * We simply do not advertise TS support.
                 */
                tmp_opt.saw_tstamp = 0;
-               tmp_opt.tstamp_ok  = 0;
-       }
+
        tmp_opt.tstamp_ok = tmp_opt.saw_tstamp;

        tcp_openreq_init(req, &tmp_opt, skb);
