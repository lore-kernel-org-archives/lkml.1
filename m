Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbYJJIYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYJJIYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYJJIYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:24:01 -0400
Received: from sidv0150.hsr.ch ([152.96.52.150]:60382 "EHLO strongswan.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYJJIYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:24:00 -0400
Message-ID: <48EF1108.5030008@strongswan.org>
Date: Fri, 10 Oct 2008 10:23:36 +0200
From: Tobias Brunner <tobias.brunner@strongswan.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc9] af_key: fix SADB_X_SPDDELETE response
References: <48EDF4AD.50907@strongswan.org> <20081009.144409.170605081.davem@davemloft.net>
In-Reply-To: <20081009.144409.170605081.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> This patch does not apply cleanly to net-next-2.6, a lot has
> changed in this area over the past several weeks.
> 
> Please respin this so that I can add it, thanks.

Please find the patch for net-next-2.6 below.

Thanks,
	Tobias

---

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 362fe31..e55e044 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2341,6 +2341,7 @@ static int pfkey_spddelete(struct sock *sk, struct sk_buff *skb, struct sadb_msg
 
 	c.seq = hdr->sadb_msg_seq;
 	c.pid = hdr->sadb_msg_pid;
+	c.data.byid = 0;
 	c.event = XFRM_MSG_DELPOLICY;
 	km_policy_notify(xp, pol->sadb_x_policy_dir-1, &c);
 
