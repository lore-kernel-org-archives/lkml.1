Return-Path: <linux-kernel-owner+w=401wt.eu-S1759361AbYG0VnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759361AbYG0VnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 17:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757727AbYG0VnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 17:43:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44571 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757614AbYG0VnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 17:43:02 -0400
Date: Sun, 27 Jul 2008 23:42:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [patch] Re: [bug, build failure] Re: [PATCH] missing bits of
	net-namespace / sysctl
Message-ID: <20080727214250.GA5917@elte.hu>
References: <20080727075933.GB28946@ZenIV.linux.org.uk> <20080727.044118.102038262.davem@davemloft.net> <20080727213905.GA4499@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727213905.GA4499@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> hmmm:
> 
> net/ipv4/route.c: In function 'ip_static_sysctl_init':
> net/ipv4/route.c:3225: error: 'ipv4_route_path' undeclared (first use in this function)
> net/ipv4/route.c:3225: error: (Each undeclared identifier is reported only once
> net/ipv4/route.c:3225: error: for each function it appears in.)
> net/ipv4/route.c:3225: error: 'ipv4_route_table' undeclared (first use in this function)
>  
> 64-bit x86 config attached.

minimal fix is below.

	Ingo

>From b8406d18c942261bc98b3b749204881b52ef7d18 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 27 Jul 2008 23:51:45 +0200
Subject: [PATCH] net/ipv4/route.c: fix build error

fix:

net/ipv4/route.c: In function 'ip_static_sysctl_init':
net/ipv4/route.c:3225: error: 'ipv4_route_path' undeclared (first use in this function)
net/ipv4/route.c:3225: error: (Each undeclared identifier is reported only once
net/ipv4/route.c:3225: error: for each function it appears in.)
net/ipv4/route.c:3225: error: 'ipv4_route_table' undeclared (first use in this function)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 net/ipv4/route.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 380d647..d7bf056 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3222,7 +3222,9 @@ int __init ip_rt_init(void)
  */
 void __init ip_static_sysctl_init(void)
 {
+#ifdef CONFIG_SYSCTL
 	register_sysctl_paths(ipv4_route_path, ipv4_route_table);
+#endif
 }
 
 EXPORT_SYMBOL(__ip_select_ident);
