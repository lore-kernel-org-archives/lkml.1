Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbYJGA72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbYJGA72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbYJGApi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:45:38 -0400
Received: from ns1.suse.de ([195.135.220.2]:47078 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757378AbYJGApf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:45:35 -0400
Date: Mon, 6 Oct 2008 17:39:49 -0700
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
       alan@lxorguk.ukuu.org.uk, Arnaud Ebalard <arno@natisbad.org>,
       Benjamin Thery <benjamin.thery@bull.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 52/71] XFRM,IPv6: initialize
	ip6_dst_blackhole_ops.kmem_cachep
Message-ID: <20081007003949.GA3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0002-XFRM-IPv6-initialize-ip6_dst_blackhole_ops.kmem_cac.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Arnaud Ebalard <arno@natisbad.org>

[ Upstream commit 5dc121e9a7a8a3721cefeb07f3559f50fbedc67e ]

ip6_dst_blackhole_ops.kmem_cachep is not expected to be NULL (i.e. to
be initialized) when dst_alloc() is called from ip6_dst_blackhole().
Otherwise, it results in the following (xfrm_larval_drop is now set to
1 by default):

[   78.697642] Unable to handle kernel paging request for data at address 0x0000004c
[   78.703449] Faulting instruction address: 0xc0097f54
[   78.786896] Oops: Kernel access of bad area, sig: 11 [#1]
[   78.792791] PowerMac
[   78.798383] Modules linked in: btusb usbhid bluetooth b43 mac80211 cfg80211 ehci_hcd ohci_hcd sungem sungem_phy usbcore ssb
[   78.804263] NIP: c0097f54 LR: c0334a28 CTR: c002d430
[   78.809997] REGS: eef19ad0 TRAP: 0300   Not tainted  (2.6.27-rc5)
[   78.815743] MSR: 00001032 <ME,IR,DR>  CR: 22242482  XER: 20000000
[   78.821550] DAR: 0000004c, DSISR: 40000000
[   78.827278] TASK = eef0df40[3035] 'mip6d' THREAD: eef18000
[   78.827408] GPR00: 00001032 eef19b80 eef0df40 00000000 00008020 eef19c30 00000001 00000000
[   78.833249] GPR08: eee5101c c05a5c10 ef9ad500 00000000 24242422 1005787c 00000000 1004f960
[   78.839151] GPR16: 00000000 10024e90 10050040 48030018 0fe44150 00000000 00000000 eef19c30
[   78.845046] GPR24: eef19e44 00000000 eef19bf8 efb37c14 eef19bf8 00008020 00009032 c0596064
[   78.856671] NIP [c0097f54] kmem_cache_alloc+0x20/0x94
[   78.862581] LR [c0334a28] dst_alloc+0x40/0xc4
[   78.868451] Call Trace:
[   78.874252] [eef19b80] [c03c1810] ip6_dst_lookup_tail+0x1c8/0x1dc (unreliable)
[   78.880222] [eef19ba0] [c0334a28] dst_alloc+0x40/0xc4
[   78.886164] [eef19bb0] [c03cd698] ip6_dst_blackhole+0x28/0x1cc
[   78.892090] [eef19be0] [c03d9be8] rawv6_sendmsg+0x75c/0xc88
[   78.897999] [eef19cb0] [c038bca4] inet_sendmsg+0x4c/0x78
[   78.903907] [eef19cd0] [c03207c8] sock_sendmsg+0xac/0xe4
[   78.909734] [eef19db0] [c03209e4] sys_sendmsg+0x1e4/0x2a0
[   78.915540] [eef19f00] [c03220a8] sys_socketcall+0xfc/0x210
[   78.921406] [eef19f40] [c0014b3c] ret_from_syscall+0x0/0x38
[   78.927295] --- Exception: c01 at 0xfe2d730
[   78.927297]     LR = 0xfe2d71c
[   78.939019] Instruction dump:
[   78.944835] 91640018 9144001c 900a0000 4bffff44 9421ffe0 7c0802a6 bf810010 7c9d2378
[   78.950694] 90010024 7fc000a6 57c0045e 7c000124 <83e3004c> 8383005c 2f9f0000 419e0050
[   78.956464] ---[ end trace 05fa1ed7972487a1 ]---

As commented by Benjamin Thery, the bug was introduced by
f2fc6a54585a1be6669613a31fbaba2ecbadcd36, while adding network
namespaces support to ipv6 routes.

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Acked-by: Benjamin Thery <benjamin.thery@bull.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/route.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2718,6 +2718,8 @@ int __init ip6_route_init(void)
 	if (ret)
 		goto out_kmem_cache;
 
+	ip6_dst_blackhole_ops.kmem_cachep = ip6_dst_ops_template.kmem_cachep;
+
 	/* Registering of the loopback is done before this portion of code,
 	 * the loopback reference in rt6_info will not be taken, do it
 	 * manually for init_net */

-- 
