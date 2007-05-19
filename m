Return-Path: <linux-kernel-owner+w=401wt.eu-S1759971AbXESFPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971AbXESFPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 01:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbXESFPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 01:15:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746AbXESFPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 01:15:11 -0400
Message-ID: <464E8763.3010609@redhat.com>
Date: Sat, 19 May 2007 13:13:07 +0800
From: Eugene Teo <eteo@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [2.6 patch] net/llc/llc_conn.c: fix possible NULL dereference
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

skb_peek() might return an empty list. skb should be checked before calling
llc_pdu_sn_hdr() with it.

Spotted by the Coverity checker.

Signed-off-by: Eugene Teo <eteo@redhat.com>

diff --git a/net/llc/llc_conn.c b/net/llc/llc_conn.c
index 3b8cfbe..28a3994 100644
--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -323,7 +323,8 @@ int llc_conn_remove_acked_pdus(struct sock *sk, u8 nr, u16
*how_many_unacked)

        if (!q_len)
                goto out;
-       skb = skb_peek(&llc->pdu_unack_q);
+       if (! (skb = skb_peek(&llc->pdu_unack_q)))
+               goto out;
        pdu = llc_pdu_sn_hdr(skb);

        /* finding position of last acked pdu in queue */

