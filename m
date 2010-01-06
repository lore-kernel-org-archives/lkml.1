Return-Path: <linux-kernel-owner+w=401wt.eu-S932201Ab0AFBVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201Ab0AFBVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 20:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481Ab0AFBUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 20:20:47 -0500
Received: from mail.perches.com ([173.55.12.10]:1531 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003Ab0AFBU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 20:20:27 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Wensong Zhang <wensong@linux-vs.org>, Simon Horman <horms@verge.net.au>,
       Julian Anastasov <ja@ssi.bg>, Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netfilter@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH 6/8] net/netfilter/ipvs/ip_vs_ftp.c: Use standardized format in sprintf
Date: Tue,  5 Jan 2010 17:20:18 -0800
Message-Id: <da25f48ee7959e83a18e3705c223c8619e508bf4.1262726222.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1262726222.git.joe@perches.com>
References: <cover.1262726222.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the same format string as net/ipv4/netfilter/nf_nat_ftp.c
to encode an ipv4 address and port.

Both uses should be a single common function.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/netfilter/ipvs/ip_vs_ftp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 33e2c79..73f38ea 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -208,7 +208,7 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 		 */
 		from.ip = n_cp->vaddr.ip;
 		port = n_cp->vport;
-		sprintf(buf, "%d,%d,%d,%d,%d,%d", NIPQUAD(from.ip),
+		sprintf(buf, "%u,%u,%u,%u,%u,%u", NIPQUAD(from.ip),
 			(ntohs(port)>>8)&255, ntohs(port)&255);
 		buf_len = strlen(buf);
 
-- 
1.6.6.rc0.57.gad7a

