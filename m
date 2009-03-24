Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZCXWit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZCXWit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZCXWig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:38:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33252
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752826AbZCXWif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:38:35 -0400
Date: Tue, 24 Mar 2009 15:38:22 -0700 (PDT)
Message-Id: <20090324.153822.75287783.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: netdev@vger.kernel.org, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] iproute2 v2.6.29
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090324153427.3ff0dfdb@nehalam>
References: <20090324153427.3ff0dfdb@nehalam>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2OMdMqu027050

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Tue, 24 Mar 2009 15:34:27 -0700

> Trying to stay on top of things (for a change).
> 
> New version of iproute2 utilities that includes bug fixes and
> support for all the new features in kernel 2.6.29.
> 
>   http://devresources.linux-foundation.org/dev/iproute2/download/iproute2-2.6.29.tar.bz2

Some build failures here:

gcc -D_GNU_SOURCE -O2 -Wstrict-prototypes -Wall -I../include -DRESOLVE_HOSTNAMES -DLIBDIR=\"/usr/lib/\"   -c -o link_gre.o link_gre.c
In file included from link_gre.c:15:
../include/linux/if_tunnel.h:33: error: field â€˜iphâ€™ has incomplete type
link_gre.c: In function â€˜gre_parse_optâ€™:
link_gre.c:136: warning: implicit declaration of function â€˜__constant_htonsâ€™

I seem to remember messing with the kernel headers in this
area recently... yes, indeed:

commit 0afd4a21ba7d75e93fa79cf05d7a21774e149c0f
Author: David S. Miller <davem@davemloft.net>
Date:   Mon Feb 2 13:27:44 2009 -0800

    net: Fix userland breakage wrt. linux/if_tunnel.h
    
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

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 12e9a29..6a9bb97 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -89,7 +89,6 @@ header-y += if_ppp.h
 header-y += if_slip.h
 header-y += if_strip.h
 header-y += if_tun.h
-header-y += if_tunnel.h
 header-y += in_route.h
 header-y += ioctl.h
 header-y += ip6_tunnel.h
@@ -235,6 +234,7 @@ unifdef-y += if_phonet.h
 unifdef-y += if_pppol2tp.h
 unifdef-y += if_pppox.h
 unifdef-y += if_tr.h
+unifdef-y += if_tunnel.h
 unifdef-y += if_vlan.h
 unifdef-y += igmp.h
 unifdef-y += inet_diag.h
diff --git a/include/linux/if_tunnel.h b/include/linux/if_tunnel.h
index aeab2cb..82c4362 100644
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
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
