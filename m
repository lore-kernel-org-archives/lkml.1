Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbXD0WGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbXD0WGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbXD0WGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:06:00 -0400
Received: from canuck.infradead.org ([209.217.80.40]:49942 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463AbXD0WFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:05:23 -0400
Date: Fri, 27 Apr 2007 15:02:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.21.1
Message-ID: <20070427220255.GB2315@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427220216.GA2315@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index d970cb1..58c08d1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 21
-EXTRAVERSION =
+EXTRAVERSION = .1
 NAME = Nocturnal Monster Puppy
 
 # *DOCUMENTATION*
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index cac06c4..444a56b 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -777,6 +777,10 @@ static void nl_fib_lookup(struct fib_result_nl *frn, struct fib_table *tb )
 							    .tos = frn->fl_tos,
 							    .scope = frn->fl_scope } } };
 
+#ifdef CONFIG_IP_MULTIPLE_TABLES
+	res.r = NULL;
+#endif
+
 	frn->err = -ENOENT;
 	if (tb) {
 		local_bh_disable();
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index fb39604..3205ec9 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -396,6 +396,7 @@ static int ipv6_rthdr_rcv(struct sk_buff **skbp)
 
 	switch (hdr->type) {
 #ifdef CONFIG_IPV6_MIP6
+	case IPV6_SRCRT_TYPE_2:
 		break;
 #endif
 	case IPV6_SRCRT_TYPE_0:
