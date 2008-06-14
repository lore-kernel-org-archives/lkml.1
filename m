Return-Path: <linux-kernel-owner+w=401wt.eu-S1763362AbYFNAUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763362AbYFNAUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761598AbYFNAOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:14:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:51928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760746AbYFNAOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:14:05 -0400
Date: Fri, 13 Jun 2008 17:11:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
       Pavel Emelyanov <xemul@openvz.org>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 24/47] vlan: Correctly handle device notifications for
	layered VLAN devices
Message-ID: <20080614001126.GX24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vlan-correctly-handle-device-notifications-for-layered-vlan-devices.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[ upstream commit: 81d85346b3fcd8b3167eac8b5fb415a210bd4345 ]

Commit 30688a9 ([VLAN]: Handle vlan devices net namespace changing)
changed the device notifier to special-case notifications for VLAN
devices, effectively disabling state propagation to underlying VLAN
devices. This is needed for layered VLANs though, so restore the
original behaviour.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/8021q/vlan.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -397,10 +397,8 @@ static int vlan_device_event(struct noti
 	if (dev->nd_net != &init_net)
 		return NOTIFY_DONE;
 
-	if (is_vlan_dev(dev)) {
+	if (is_vlan_dev(dev))
 		__vlan_device_event(dev, event);
-		goto out;
-	}
 
 	grp = __vlan_find_group(dev->ifindex);
 	if (!grp)

-- 
