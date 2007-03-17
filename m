Return-Path: <linux-kernel-owner+w=401wt.eu-S1753729AbXCQO6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbXCQO6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 10:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbXCQO6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 10:58:40 -0400
Received: from stinky.trash.net ([213.144.137.162]:45391 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbXCQO6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 10:58:38 -0400
Message-ID: <45FC0226.2010305@trash.net>
Date: Sat, 17 Mar 2007 15:58:46 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Kevin Baradon <kevin.baradon@gmail.com>
CC: linux-kernel@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@lists.netfilter.org>
Subject: Re: [2.6.21-rc{3,4} problem]: missing dependency on NF_NAT
References: <bd87e7590703170738q2363274fx120630d5d4e3279@mail.gmail.com>
In-Reply-To: <bd87e7590703170738q2363274fx120630d5d4e3279@mail.gmail.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: multipart/mixed;
 boundary="------------060401000203020202090307"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060401000203020202090307
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

Kevin Baradon wrote:
> Compiling kernel 2.6.21-rc3 gives me the following errors :
> 
>  LD      .tmp_vmlinux1
> net/built-in.o: dans la fonction « nfnetlink_parse_nat_proto »:
> nf_conntrack_netlink.c:(.text+0x28db9): référence indéfinie vers «
> nf_nat_proto_find_get »
> [...]
> 
> Also occurs with 2.6.21-rc4.
> Setting CONFIG_NF_NAT to 'y' fixes problem.


Thanks, I queued this patch, which should fix it.

--------------060401000203020202090307
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: nf_conntrack_netlink: add missing dependency on NF_NAT

NF_CT_NETLINK=y, NF_NAT=m results in:

 LD      .tmp_vmlinux1
 net/built-in.o: dans la fonction « nfnetlink_parse_nat_proto »:
 nf_conntrack_netlink.c:(.text+0x28db9): référence indéfinie vers « nf_nat_proto_find_get »
 nf_conntrack_netlink.c:(.text+0x28dd6): référence indéfinie vers « nf_nat_proto_put »
 net/built-in.o: dans la fonction « ctnetlink_new_conntrack »:
 nf_conntrack_netlink.c:(.text+0x29959): référence indéfinie vers « nf_nat_setup_info »
 nf_conntrack_netlink.c:(.text+0x29b35): référence indéfinie vers « nf_nat_setup_info »
 nf_conntrack_netlink.c:(.text+0x29cf7): référence indéfinie vers « nf_nat_setup_info »
 nf_conntrack_netlink.c:(.text+0x29de2): référence indéfinie vers « nf_nat_setup_info »
 make: *** [.tmp_vmlinux1] Erreur 1 

Reported by Kevin Baradon <kevin.baradon@gmail.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9b8ea8f4f4091c6e4424b46e8d56bb0366dfd3ee
tree 70c237a3e129df7366ac4a52f6efa142aa0a7d98
parent cd05a1f818073a623455a58e756c5b419fc98db9
author Patrick McHardy <kaber@trash.net> Sat, 17 Mar 2007 15:55:27 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 17 Mar 2007 15:55:27 +0100

 net/netfilter/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 253fce3..54698af 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -275,6 +275,7 @@ config NF_CT_NETLINK
 	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK && NETFILTER_NETLINK
 	depends on NF_CONNTRACK!=y || NETFILTER_NETLINK!=m
+	depends on NF_NAT=n || NF_NAT
 	help
 	  This option enables support for a netlink-based userspace interface
 

--------------060401000203020202090307--
