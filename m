Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbYICRv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbYICRv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbYICRvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:51:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:58667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874AbYICRvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:51:09 -0400
Date: Wed, 3 Sep 2008 10:32:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Ayaz Abdulla <aabdulla@nvidia.com>,
       Jeff Garzik <jgarzik@pobox.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 07/16] forcedeth: fix checksum flag
Message-ID: <20080903173256.GH10429@suse.de>
References: <20080903172849.927077124@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="forcedeth-fix-checksum-flag.patch"
In-Reply-To: <20080903173218.GA10429@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ayaz Abdulla <aabdulla@nvidia.com>

commit edcfe5f7e307846e578fb88d69fa27051fded0ab upstream

Fix the checksum feature advertised in device flags.  The hardware support
TCP/UDP over IPv4 and TCP/UDP over IPv6 (without IPv6 extension headers).
However, the kernel feature flags do not distinguish IPv6 with/without
extension headers.

Therefore, the driver needs to use NETIF_F_IP_CSUM instead of
NETIF_F_HW_CSUM since the latter includes all IPv6 packets.

A future patch can be created to check for extension headers and perform
software checksum calculation.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/forcedeth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -5249,7 +5249,7 @@ static int __devinit nv_probe(struct pci
 	if (id->driver_data & DEV_HAS_CHECKSUM) {
 		np->rx_csum = 1;
 		np->txrxctl_bits |= NVREG_TXRXCTL_RXCHECK;
-		dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
+		dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
 		dev->features |= NETIF_F_TSO;
 	}
 
@@ -5548,7 +5548,7 @@ static int __devinit nv_probe(struct pci
 
 	dev_printk(KERN_INFO, &pci_dev->dev, "%s%s%s%s%s%s%s%s%s%sdesc-v%u\n",
 		   dev->features & NETIF_F_HIGHDMA ? "highdma " : "",
-		   dev->features & (NETIF_F_HW_CSUM | NETIF_F_SG) ?
+		   dev->features & (NETIF_F_IP_CSUM | NETIF_F_SG) ?
 		   	"csum " : "",
 		   dev->features & (NETIF_F_HW_VLAN_RX | NETIF_F_HW_VLAN_TX) ?
 		   	"vlan " : "",

-- 
