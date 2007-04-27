Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbXD0WG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbXD0WG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbXD0WF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:05:58 -0400
Received: from canuck.infradead.org ([209.217.80.40]:49936 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450AbXD0WFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:05:19 -0400
Date: Fri, 27 Apr 2007 14:56:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.20.10
Message-ID: <20070427215614.GB1817@kroah.com>
References: <20070427215556.GA1817@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427215556.GA1817@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 3e7e6c7..b9ba823 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 20
-EXTRAVERSION = .9
+EXTRAVERSION = .10
 NAME = Homicidal Dwarf Hamster
 
 # *DOCUMENTATION*
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index fa2cb8c..30aae76 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -773,6 +773,10 @@ static void nl_fib_lookup(struct fib_result_nl *frn, struct fib_table *tb )
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
index 5fd7cf9..de96e1a 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -397,6 +397,7 @@ static int ipv6_rthdr_rcv(struct sk_buff **skbp)
 
 	switch (hdr->type) {
 #ifdef CONFIG_IPV6_MIP6
+	case IPV6_SRCRT_TYPE_2:
 		break;
 #endif
 	case IPV6_SRCRT_TYPE_0:
