Return-Path: <linux-kernel-owner+w=401wt.eu-S1765991AbZBNBhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765991AbZBNBhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763378AbZBNBQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:31 -0500
Received: from kroah.org ([198.145.64.141]:50416 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762513AbZBNBQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:21 -0500
Date: Fri, 13 Feb 2009 17:13:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 23/48] net: Fix userland breakage wrt. linux/if_tunnel.h
Message-ID: <20090214011305.GX17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-fix-userland-breakage-wrt.-linux-if_tunnel.h.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 0afd4a21ba7d75e93fa79cf05d7a21774e149c0f ]

Reported by Andrew Walrond <andrew@walrond.org>

Changeset c19e654ddbe3831252f61e76a74d661e1a755530
("gre: Add netlink interface") added an include
of linux/ip.h to linux/if_tunnel.h

We can't really let that get exposed to userspace
because this conflicts with types defined in netinet/ip.h
which userland is almost certainly going to have included
either explicitly or implicitly.

So guard this include with a __KERNEL__ ifdef.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/Kbuild      |    2 +-
 include/linux/if_tunnel.h |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/if_tunnel.h
+++ b/include/linux/if_tunnel.h
@@ -2,7 +2,10 @@
 #define _IF_TUNNEL_H_
 
 #include <linux/types.h>
+
+#ifdef __KERNEL__
 #include <linux/ip.h>
+#endif
 
 #define SIOCGETTUNNEL   (SIOCDEVPRIVATE + 0)
 #define SIOCADDTUNNEL   (SIOCDEVPRIVATE + 1)
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -92,7 +92,6 @@ header-y += if_ppp.h
 header-y += if_slip.h
 header-y += if_strip.h
 header-y += if_tun.h
-header-y += if_tunnel.h
 header-y += in_route.h
 header-y += ioctl.h
 header-y += ip6_tunnel.h
@@ -241,6 +240,7 @@ unifdef-y += if_phonet.h
 unifdef-y += if_pppol2tp.h
 unifdef-y += if_pppox.h
 unifdef-y += if_tr.h
+unifdef-y += if_tunnel.h
 unifdef-y += if_vlan.h
 unifdef-y += igmp.h
 unifdef-y += inet_diag.h

