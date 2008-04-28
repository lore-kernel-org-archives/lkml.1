Return-Path: <linux-kernel-owner+w=401wt.eu-S935307AbYD1PlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935307AbYD1PlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935894AbYD1PjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:39:17 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34998 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935887AbYD1PjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:39:15 -0400
Date: Mon, 28 Apr 2008 18:38:42 +0300
From: Adrian Bunk <bunk@kernel.org>
To: davem@davemloft.net
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com,
       Ingo Molnar <mingo@elte.hu>, netdev@vger.kernel.org
Subject: [2.6 patch] net/ipv4/ip_output.c:ip_send_check() mustn't be inline
Message-ID: <20080428153842.GF2813@cs181133002.pp.htv.fi>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080426172222.GD17345@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error with UML and gcc 4.3:

<--  snip  -->

...
  CC      net/ipv4/ip_output.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv4/ip_output.c: In function ‘__ip_local_out’:
/home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv4/ip_output.c:89: sorry, unimplemented: inlining failed in call to ‘ip_send_check’: function body not available
/home/bunk/linux/kernel-2.6/git/linux-2.6/net/ipv4/ip_output.c:99: sorry, unimplemented: called from here
make[3]: *** [net/ipv4/ip_output.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
936e490777359bfde622148ff5af1e19d8c248b5 diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 0834926..985a719 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -85,7 +85,7 @@
 int sysctl_ip_default_ttl __read_mostly = IPDEFTTL;
 
 /* Generate a checksum for an outgoing IP datagram. */
-__inline__ void ip_send_check(struct iphdr *iph)
+void ip_send_check(struct iphdr *iph)
 {
 	iph->check = 0;
 	iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);

