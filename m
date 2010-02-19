Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0BSRKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:10:34 -0500
Received: from kroah.org ([198.145.64.141]:57621 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab0BSRAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:45 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:44 2010
Message-Id: <20100219163244.471577875@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Patrick McHardy <kaber@trash.net>
Subject: [49/93] netfilter: xtables: compat out of scope fix
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit 14c7dbe043d01a83a30633ab6b109ba2ac61d9f7 upstream.

As per C99 6.2.4(2) when temporary table data goes out of scope,
the behaviour is undefined:

	if (compat) {
		struct foo tmp;
		...
		private = &tmp;
	}
	[dereference private]

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/netfilter/arp_tables.c |    4 ++--
 net/ipv4/netfilter/ip_tables.c  |    4 ++--
 net/ipv6/netfilter/ip6_tables.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -925,10 +925,10 @@ static int get_info(struct net *net, voi
 	if (t && !IS_ERR(t)) {
 		struct arpt_getinfo info;
 		const struct xt_table_info *private = t->private;
-
 #ifdef CONFIG_COMPAT
+		struct xt_table_info tmp;
+
 		if (compat) {
-			struct xt_table_info tmp;
 			ret = compat_table_info(private, &tmp);
 			xt_compat_flush_offsets(NFPROTO_ARP);
 			private = &tmp;
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1132,10 +1132,10 @@ static int get_info(struct net *net, voi
 	if (t && !IS_ERR(t)) {
 		struct ipt_getinfo info;
 		const struct xt_table_info *private = t->private;
-
 #ifdef CONFIG_COMPAT
+		struct xt_table_info tmp;
+
 		if (compat) {
-			struct xt_table_info tmp;
 			ret = compat_table_info(private, &tmp);
 			xt_compat_flush_offsets(AF_INET);
 			private = &tmp;
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1164,10 +1164,10 @@ static int get_info(struct net *net, voi
 	if (t && !IS_ERR(t)) {
 		struct ip6t_getinfo info;
 		const struct xt_table_info *private = t->private;
-
 #ifdef CONFIG_COMPAT
+		struct xt_table_info tmp;
+
 		if (compat) {
-			struct xt_table_info tmp;
 			ret = compat_table_info(private, &tmp);
 			xt_compat_flush_offsets(AF_INET6);
 			private = &tmp;


