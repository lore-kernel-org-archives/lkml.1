Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYJ1EHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYJ1EHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYJ1EGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:06:48 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:60758 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYJ1EGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=OJOcOgHYlPgsvVesnA8Hyq5SJtML7wI3fnO5hKmTLJIZ6384sQ9hiSPzFpRDXgx2op
         goq92DIOYsIfPVIZmgP74pMXije5e8MzerIJnkQM1FHUaJwzTpBct+8Ip/OYUTXf1iD7
         5E3xFvNegfCciH3bT4aG5IcnsiWGBc91fRu90=
Subject: [RFC PATCH 3/5] net/ipv4, net/ipv6: use %#p6, %p6 format strings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Johannes Berg <johannes@sipsolutions.net>, Joe Perches <joe@perches.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 21:05:18 -0700
Message-Id: <1225166718.5526.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/ipv4/tcp_input.c                           |    4 +-
 net/ipv4/tcp_timer.c                           |    4 +-
 net/ipv6/addrconf.c                            |    5 +--
 net/ipv6/addrlabel.c                           |   34 +++++++----------------
 net/ipv6/ah6.c                                 |    4 +-
 net/ipv6/anycast.c                             |    6 +---
 net/ipv6/esp6.c                                |    4 +-
 net/ipv6/exthdrs.c                             |    2 +-
 net/ipv6/icmp.c                                |    4 +-
 net/ipv6/ip6_flowlabel.c                       |    4 +-
 net/ipv6/ip6mr.c                               |    5 +--
 net/ipv6/ipcomp6.c                             |    4 +-
 net/ipv6/mcast.c                               |   10 +++---
 net/ipv6/ndisc.c                               |    7 +---
 net/ipv6/netfilter/ip6t_LOG.c                  |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    5 +--
 net/ipv6/route.c                               |    9 ++----
 net/ipv6/tcp_ipv6.c                            |    8 ++---
 18 files changed, 48 insertions(+), 73 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index d77c0d2..191c06b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2346,9 +2346,9 @@ static void DBGUNDO(struct sock *sk, const char *msg)
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	else if (sk->sk_family == AF_INET6) {
 		struct ipv6_pinfo *np = inet6_sk(sk);
-		printk(KERN_DEBUG "Undo %s " NIP6_FMT "/%u c%u l%u ss%u/%u p%u\n",
+		printk(KERN_DEBUG "Undo %s %p6/%u c%u l%u ss%u/%u p%u\n",
 		       msg,
-		       NIP6(np->daddr), ntohs(inet->dport),
+		       &np->daddr, ntohs(inet->dport),
 		       tp->snd_cwnd, tcp_left_out(tp),
 		       tp->snd_ssthresh, tp->prior_ssthresh,
 		       tp->packets_out);
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 6b6dff1..4e6ee52 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -306,8 +306,8 @@ static void tcp_retransmit_timer(struct sock *sk)
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 		else if (sk->sk_family == AF_INET6) {
 			struct ipv6_pinfo *np = inet6_sk(sk);
-			LIMIT_NETDEBUG(KERN_DEBUG "TCP: Treason uncloaked! Peer " NIP6_FMT ":%u/%u shrinks window %u:%u. Repaired.\n",
-			       NIP6(np->daddr), ntohs(inet->dport),
+			LIMIT_NETDEBUG(KERN_DEBUG "TCP: Treason uncloaked! Peer %p6:%u/%u shrinks window %u:%u. Repaired.\n",
+			       &np->daddr, ntohs(inet->dport),
 			       inet->num, tp->snd_una, tp->snd_nxt);
 		}
 #endif
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index eea9542..113c4d9 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2986,9 +2986,8 @@ static void if6_seq_stop(struct seq_file *seq, void *v)
 static int if6_seq_show(struct seq_file *seq, void *v)
 {
 	struct inet6_ifaddr *ifp = (struct inet6_ifaddr *)v;
-	seq_printf(seq,
-		   NIP6_SEQFMT " %02x %02x %02x %02x %8s\n",
-		   NIP6(ifp->addr),
+	seq_printf(seq, "%#p6 %02x %02x %02x %02x %8s\n",
+		   &ifp->addr,
 		   ifp->idev->dev->ifindex,
 		   ifp->prefix_len,
 		   ifp->scope,
diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
index 0890903..2e25334 100644
--- a/net/ipv6/addrlabel.c
+++ b/net/ipv6/addrlabel.c
@@ -186,10 +186,8 @@ u32 ipv6_addr_label(struct net *net,
 	label = p ? p->label : IPV6_ADDR_LABEL_DEFAULT;
 	rcu_read_unlock();
 
-	ADDRLABEL(KERN_DEBUG "%s(addr=" NIP6_FMT ", type=%d, ifindex=%d) => %08x\n",
-			__func__,
-			NIP6(*addr), type, ifindex,
-			label);
+	ADDRLABEL(KERN_DEBUG "%s(addr=%p6, type=%d, ifindex=%d) => %08x\n",
+		  __func__, addr, type, ifindex, label);
 
 	return label;
 }
@@ -203,11 +201,8 @@ static struct ip6addrlbl_entry *ip6addrlbl_alloc(struct net *net,
 	struct ip6addrlbl_entry *newp;
 	int addrtype;
 
-	ADDRLABEL(KERN_DEBUG "%s(prefix=" NIP6_FMT ", prefixlen=%d, ifindex=%d, label=%u)\n",
-			__func__,
-			NIP6(*prefix), prefixlen,
-			ifindex,
-			(unsigned int)label);
+	ADDRLABEL(KERN_DEBUG "%s(prefix=%p6, prefixlen=%d, ifindex=%d, label=%u)\n",
+		  __func__, prefix, prefixlen, ifindex, (unsigned int)label);
 
 	addrtype = ipv6_addr_type(prefix) & (IPV6_ADDR_MAPPED | IPV6_ADDR_COMPATv4 | IPV6_ADDR_LOOPBACK);
 
@@ -294,12 +289,9 @@ static int ip6addrlbl_add(struct net *net,
 	struct ip6addrlbl_entry *newp;
 	int ret = 0;
 
-	ADDRLABEL(KERN_DEBUG "%s(prefix=" NIP6_FMT ", prefixlen=%d, ifindex=%d, label=%u, replace=%d)\n",
-			__func__,
-			NIP6(*prefix), prefixlen,
-			ifindex,
-			(unsigned int)label,
-			replace);
+	ADDRLABEL(KERN_DEBUG "%s(prefix=%p6, prefixlen=%d, ifindex=%d, label=%u, replace=%d)\n",
+		  __func__, prefix, prefixlen, ifindex, (unsigned int)label,
+		  replace);
 
 	newp = ip6addrlbl_alloc(net, prefix, prefixlen, ifindex, label);
 	if (IS_ERR(newp))
@@ -321,10 +313,8 @@ static int __ip6addrlbl_del(struct net *net,
 	struct hlist_node *pos, *n;
 	int ret = -ESRCH;
 
-	ADDRLABEL(KERN_DEBUG "%s(prefix=" NIP6_FMT ", prefixlen=%d, ifindex=%d)\n",
-			__func__,
-			NIP6(*prefix), prefixlen,
-			ifindex);
+	ADDRLABEL(KERN_DEBUG "%s(prefix=%p6, prefixlen=%d, ifindex=%d)\n",
+		  __func__, prefix, prefixlen, ifindex);
 
 	hlist_for_each_entry_safe(p, pos, n, &ip6addrlbl_table.head, list) {
 		if (p->prefixlen == prefixlen &&
@@ -347,10 +337,8 @@ static int ip6addrlbl_del(struct net *net,
 	struct in6_addr prefix_buf;
 	int ret;
 
-	ADDRLABEL(KERN_DEBUG "%s(prefix=" NIP6_FMT ", prefixlen=%d, ifindex=%d)\n",
-			__func__,
-			NIP6(*prefix), prefixlen,
-			ifindex);
+	ADDRLABEL(KERN_DEBUG "%s(prefix=%p6, prefixlen=%d, ifindex=%d)\n",
+		  __func__, prefix), prefixlen, ifindex);
 
 	ipv6_addr_prefix(&prefix_buf, prefix, prefixlen);
 	spin_lock(&ip6addrlbl_table.lock);
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 2ff0c82..9bc43f2 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -419,8 +419,8 @@ static void ah6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	if (!x)
 		return;
 
-	NETDEBUG(KERN_DEBUG "pmtu discovery on SA AH/%08x/" NIP6_FMT "\n",
-		 ntohl(ah->spi), NIP6(iph->daddr));
+	NETDEBUG(KERN_DEBUG "pmtu discovery on SA AH/%08x/%p6\n",
+		 ntohl(ah->spi), &iph->daddr);
 
 	xfrm_state_put(x);
 }
diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
index 8336cd8..ae494e3 100644
--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -512,11 +512,9 @@ static int ac6_seq_show(struct seq_file *seq, void *v)
 	struct ifacaddr6 *im = (struct ifacaddr6 *)v;
 	struct ac6_iter_state *state = ac6_seq_private(seq);
 
-	seq_printf(seq,
-		   "%-4d %-15s " NIP6_SEQFMT " %5d\n",
+	seq_printf(seq, "%-4d %-15s %#p6 %5d\n",
 		   state->dev->ifindex, state->dev->name,
-		   NIP6(im->aca_addr),
-		   im->aca_users);
+		   &im->aca_addr, im->aca_users);
 	return 0;
 }
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index b181b08..ec4be18 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -367,8 +367,8 @@ static void esp6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	x = xfrm_state_lookup((xfrm_address_t *)&iph->daddr, esph->spi, IPPROTO_ESP, AF_INET6);
 	if (!x)
 		return;
-	printk(KERN_DEBUG "pmtu discovery on SA ESP/%08x/" NIP6_FMT "\n",
-			ntohl(esph->spi), NIP6(iph->daddr));
+	printk(KERN_DEBUG "pmtu discovery on SA ESP/%08x/%p6\n",
+			ntohl(esph->spi), &iph->daddr);
 	xfrm_state_put(x);
 }
 
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 6bfffec..a890514 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -219,7 +219,7 @@ static int ipv6_dest_hao(struct sk_buff *skb, int optoff)
 
 	if (!(ipv6_addr_type(&hao->addr) & IPV6_ADDR_UNICAST)) {
 		LIMIT_NETDEBUG(
-			KERN_DEBUG "hao is not an unicast addr: " NIP6_FMT "\n", NIP6(hao->addr));
+			KERN_DEBUG "hao is not an unicast addr: %p6\n", &hao->addr);
 		goto discard;
 	}
 
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 9b7d19a..1b72446 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -680,8 +680,8 @@ static int icmpv6_rcv(struct sk_buff *skb)
 		skb->csum = ~csum_unfold(csum_ipv6_magic(saddr, daddr, skb->len,
 					     IPPROTO_ICMPV6, 0));
 		if (__skb_checksum_complete(skb)) {
-			LIMIT_NETDEBUG(KERN_DEBUG "ICMPv6 checksum failed [" NIP6_FMT " > " NIP6_FMT "]\n",
-				       NIP6(*saddr), NIP6(*daddr));
+			LIMIT_NETDEBUG(KERN_DEBUG "ICMPv6 checksum failed [%p6 > %p6]\n",
+				       saddr, daddr);
 			goto discard_it;
 		}
 	}
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index 37a4e77..d571023 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -696,14 +696,14 @@ static int ip6fl_seq_show(struct seq_file *seq, void *v)
 	else {
 		struct ip6_flowlabel *fl = v;
 		seq_printf(seq,
-			   "%05X %-1d %-6d %-6d %-6ld %-8ld " NIP6_SEQFMT " %-4d\n",
+			   "%05X %-1d %-6d %-6d %-6ld %-8ld %#p6 %-4d\n",
 			   (unsigned)ntohl(fl->label),
 			   fl->share,
 			   (unsigned)fl->owner,
 			   atomic_read(&fl->users),
 			   fl->linger/HZ,
 			   (long)(fl->expires - jiffies)/HZ,
-			   NIP6(fl->dst),
+			   &fl->dst,
 			   fl->opt ? fl->opt->opt_nflen : 0);
 	}
 	return 0;
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 182f8a1..798e6a2 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -297,9 +297,8 @@ static int ipmr_mfc_seq_show(struct seq_file *seq, void *v)
 		const struct mfc6_cache *mfc = v;
 		const struct ipmr_mfc_iter *it = seq->private;
 
-		seq_printf(seq,
-			   NIP6_FMT " " NIP6_FMT " %-3d %8ld %8ld %8ld",
-			   NIP6(mfc->mf6c_mcastgrp), NIP6(mfc->mf6c_origin),
+		seq_printf(seq, "%p6 %p6 %-3d %8ld %8ld %8ld",
+			   &mfc->mf6c_mcastgrp, &mfc->mf6c_origin,
 			   mfc->mf6c_parent,
 			   mfc->mfc_un.res.pkt,
 			   mfc->mfc_un.res.bytes,
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 4545e43..9566d8f 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -67,8 +67,8 @@ static void ipcomp6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	if (!x)
 		return;
 
-	printk(KERN_DEBUG "pmtu discovery on SA IPCOMP/%08x/" NIP6_FMT "\n",
-			spi, NIP6(iph->daddr));
+	printk(KERN_DEBUG "pmtu discovery on SA IPCOMP/%08x/%p6\n",
+			spi, &iph->daddr);
 	xfrm_state_put(x);
 }
 
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index d7b3c6d..4416cdc 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2430,9 +2430,9 @@ static int igmp6_mc_seq_show(struct seq_file *seq, void *v)
 	struct igmp6_mc_iter_state *state = igmp6_mc_seq_private(seq);
 
 	seq_printf(seq,
-		   "%-4d %-15s " NIP6_SEQFMT " %5d %08X %ld\n",
+		   "%-4d %-15s %#p6 %5d %08X %ld\n",
 		   state->dev->ifindex, state->dev->name,
-		   NIP6(im->mca_addr),
+		   &im->mca_addr,
 		   im->mca_users, im->mca_flags,
 		   (im->mca_flags&MAF_TIMER_RUNNING) ?
 		   jiffies_to_clock_t(im->mca_timer.expires-jiffies) : 0);
@@ -2591,10 +2591,10 @@ static int igmp6_mcf_seq_show(struct seq_file *seq, void *v)
 			   "Source Address", "INC", "EXC");
 	} else {
 		seq_printf(seq,
-			   "%3d %6.6s " NIP6_SEQFMT " " NIP6_SEQFMT " %6lu %6lu\n",
+			   "%3d %6.6s %#p6 %#p6 %6lu %6lu\n",
 			   state->dev->ifindex, state->dev->name,
-			   NIP6(state->im->mca_addr),
-			   NIP6(psf->sf_addr),
+			   &state->im->mca_addr,
+			   &psf->sf_addr,
 			   psf->sf_count[MCAST_INCLUDE],
 			   psf->sf_count[MCAST_EXCLUDE]);
 	}
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 1724383..191bb07 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -647,11 +647,8 @@ static void ndisc_solicit(struct neighbour *neigh, struct sk_buff *skb)
 
 	if ((probes -= neigh->parms->ucast_probes) < 0) {
 		if (!(neigh->nud_state & NUD_VALID)) {
-			ND_PRINTK1(KERN_DEBUG
-				   "%s(): trying to ucast probe in NUD_INVALID: "
-				   NIP6_FMT "\n",
-				   __func__,
-				   NIP6(*target));
+			ND_PRINTK1(KERN_DEBUG "%s(): trying to ucast probe in NUD_INVALID: %p6\n",
+				   __func__, target);
 		}
 		ndisc_send_ns(dev, neigh, target, target, saddr);
 	} else if ((probes -= neigh->parms->app_probes) < 0) {
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index caa441d..a61ce30 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -61,7 +61,7 @@ static void dump_packet(const struct nf_loginfo *info,
 	}
 
 	/* Max length: 88 "SRC=0000.0000.0000.0000.0000.0000.0000.0000 DST=0000.0000.0000.0000.0000.0000.0000.0000 " */
-	printk("SRC=" NIP6_FMT " DST=" NIP6_FMT " ", NIP6(ih->saddr), NIP6(ih->daddr));
+	printk("SRC=%p6 DST=%p6 ", &ih->saddr, &ih->daddr);
 
 	/* Max length: 44 "LEN=65535 TC=255 HOPLIMIT=255 FLOWLBL=FFFFF " */
 	printk("LEN=%Zu TC=%u HOPLIMIT=%u FLOWLBL=%u ",
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index e91db16..045c086 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -56,9 +56,8 @@ static bool ipv6_invert_tuple(struct nf_conntrack_tuple *tuple,
 static int ipv6_print_tuple(struct seq_file *s,
 			    const struct nf_conntrack_tuple *tuple)
 {
-	return seq_printf(s, "src=" NIP6_FMT " dst=" NIP6_FMT " ",
-			  NIP6(*((struct in6_addr *)tuple->src.u3.ip6)),
-			  NIP6(*((struct in6_addr *)tuple->dst.u3.ip6)));
+	return seq_printf(s, "src=%p6 dst=%p6 ",
+			  tuple->src.u3.ip6), tuple->dst.u3.ip6);
 }
 
 /*
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 89dc699..720bfed 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2408,19 +2408,16 @@ static int rt6_info_route(struct rt6_info *rt, void *p_arg)
 {
 	struct seq_file *m = p_arg;
 
-	seq_printf(m, NIP6_SEQFMT " %02x ", NIP6(rt->rt6i_dst.addr),
-		   rt->rt6i_dst.plen);
+	seq_printf(m, "%#p6 %02x ", &rt->rt6i_dst.addr, rt->rt6i_dst.plen);
 
 #ifdef CONFIG_IPV6_SUBTREES
-	seq_printf(m, NIP6_SEQFMT " %02x ", NIP6(rt->rt6i_src.addr),
-		   rt->rt6i_src.plen);
+	seq_printf(m, "%#p6 %02x ", &rt->rt6i_src.addr, rt->rt6i_src.plen);
 #else
 	seq_puts(m, "00000000000000000000000000000000 00 ");
 #endif
 
 	if (rt->rt6i_nexthop) {
-		seq_printf(m, NIP6_SEQFMT,
-			   NIP6(*((struct in6_addr *)rt->rt6i_nexthop->primary_key)));
+		seq_printf(m, "%#p6", rt->rt6i_nexthop->primary_key);
 	} else {
 		seq_puts(m, "00000000000000000000000000000000");
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index b6b356b..483550c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -872,12 +872,10 @@ static int tcp_v6_inbound_md5_hash (struct sock *sk, struct sk_buff *skb)
 
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
 		if (net_ratelimit()) {
-			printk(KERN_INFO "MD5 Hash %s for "
-			       "(" NIP6_FMT ", %u)->"
-			       "(" NIP6_FMT ", %u)\n",
+			printk(KERN_INFO "MD5 Hash %s for (%p6, %u)->(%p6, %u)\n",
 			       genhash ? "failed" : "mismatch",
-			       NIP6(ip6h->saddr), ntohs(th->source),
-			       NIP6(ip6h->daddr), ntohs(th->dest));
+			       &ip6h->saddr, ntohs(th->source),
+			       &ip6h->daddr, ntohs(th->dest));
 		}
 		return 1;
 	}
-- 
1.6.0.3.729.g6ea410


