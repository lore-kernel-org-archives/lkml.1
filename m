Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbYKOF1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbYKOF1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYKOFY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:24:56 -0500
Received: from kroah.org ([198.145.64.141]:50516 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752515AbYKOFYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:24:55 -0500
Date: Fri, 14 Nov 2008 21:23:05 -0800
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
       alan@lxorguk.ukuu.org.uk, Eilon Greenstein <eilong@broadcom.com>,
       "David S. Miller" <davem@davemloft.net>, Alex Chiang <achiang@hp.com>
Subject: [patch 07/22] bnx2x: Calling netif_carrier_off at the end of the
	probe
Message-ID: <20081115052305.GH3710@kroah.com>
References: <20081115051732.506914008@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bnx2x-calling-netif_carrier_off-at-the-end-of-the-probe.patch"
In-Reply-To: <20081115052220.GA3710@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eilon Greenstein <eilong@broadcom.com>

commit 12b56ea89e70d4b04f2f5199750310e82894ebbd upstream.

netif_carrier_off was called too early at the probe. In case of failure
or simply bad timing, this can cause a fatal error since linkwatch_event
might run too soon.

Signed-off-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Alex Chiang <achiang@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bnx2x_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/bnx2x_main.c
+++ b/drivers/net/bnx2x_main.c
@@ -10205,8 +10205,6 @@ static int __devinit bnx2x_init_one(stru
 		return -ENOMEM;
 	}
 
-	netif_carrier_off(dev);
-
 	bp = netdev_priv(dev);
 	bp->msglevel = debug;
 
@@ -10230,6 +10228,8 @@ static int __devinit bnx2x_init_one(stru
 		goto init_one_exit;
 	}
 
+	netif_carrier_off(dev);
+
 	bp->common.name = board_info[ent->driver_data].name;
 	printk(KERN_INFO "%s: %s (%c%d) PCI-E x%d %s found at mem %lx,"
 	       " IRQ %d, ", dev->name, bp->common.name,

-- 
