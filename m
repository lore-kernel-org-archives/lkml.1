Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbYLJUGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbYLJUGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbYLJUGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:06:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46780 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232AbYLJUGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:06:04 -0500
Date: Wed, 10 Dec 2008 15:06:00 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linux Netdev List <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
cc: Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] update rwlock initialization for nat_table
In-Reply-To: <49400B7F.7040607@cosmosbay.com>
Message-ID: <alpine.DEB.1.10.0812101504280.11805@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0812101314460.11805@gandalf.stny.rr.com> <49400B7F.7040607@cosmosbay.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: cleanups


Steven Rostedt (1):
      update rwlock initialization for nat_table

----
 net/ipv4/netfilter/nf_nat_rule.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
---------------------------
commit d4175059c8f95e4cd58e0efaa85610ca59469fbd
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Dec 10 15:00:09 2008 -0500

    update rwlock initialization for nat_table
    
    Impact: clean up
    
    The commit e099a173573ce1ba171092aee7bb3c72ea686e59
    (netfilter: netns nat: per-netns NAT table) renamed the
    nat_table from __nat_table to nat_table without updating the
    __RW_LOCK_UNLOCKED(__nat_table.lock).
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index bea54a6..8d489e7 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -61,7 +61,7 @@ static struct
 static struct xt_table nat_table = {
 	.name		= "nat",
 	.valid_hooks	= NAT_VALID_HOOKS,
-	.lock		= __RW_LOCK_UNLOCKED(__nat_table.lock),
+	.lock		= __RW_LOCK_UNLOCKED(nat_table.lock),
 	.me		= THIS_MODULE,
 	.af		= AF_INET,
 };


