Return-Path: <linux-kernel-owner+w=401wt.eu-S1765973AbXKOG2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765973AbXKOG2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764622AbXKOGWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:22:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45968 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764932AbXKOGWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:12 -0500
Date: Wed, 14 Nov 2007 22:20:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 12/23] Fix VLAN address syncing.
Message-ID: <20071115062041.GM8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-vlan-address-syncing.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Patrick McHardy <kaber@trash.net>

patch d932e04a5e7b146c5f9bf517714b986a432a7594 in mainline.

[PATCH] [VLAN]: Don't synchronize addresses while the vlan device is down

While the VLAN device is down, the unicast addresses are not configured
on the underlying device, so we shouldn't attempt to sync them.

Noticed by Dmitry Butskoy <buc@odusz.so-cdu.ru>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/8021q/vlan.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -629,6 +629,10 @@ static int vlan_device_event(struct noti
 			if (!vlandev)
 				continue;
 
+			flgs = vlandev->flags;
+			if (!(flgs & IFF_UP))
+				continue;
+
 			vlan_sync_address(dev, vlandev);
 		}
 		break;

-- 
