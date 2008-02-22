Return-Path: <linux-kernel-owner+w=401wt.eu-S934612AbYBVVtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934612AbYBVVtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:49:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933587AbYBVVnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:43:41 -0500
Received: from ns2.suse.de ([195.135.220.15]:60496 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933500AbYBVVnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:43:40 -0500
Date: Fri, 22 Feb 2008 13:40:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Mahoney <jeffm@suse.com>,
       Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 13/23] VIA_VELOCITY: Dont oops on MTU change.
Message-ID: <20080222214037.GN8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="via_velocity-don-t-oops-on-mtu-change.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Stephen Hemminger <shemminger@linux-foundation.org>

mainline: bd7b3f34198071d8bec05180530c362f1800ba46

Simple mtu change when device is down.
Fix http://bugzilla.kernel.org/show_bug.cgi?id=9382.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/via-velocity.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/via-velocity.c
+++ b/drivers/net/via-velocity.c
@@ -1798,6 +1798,11 @@ static int velocity_change_mtu(struct ne
 		return -EINVAL;
 	}
 
+	if (!netif_running(dev)) {
+		dev->mtu = new_mtu;
+		return 0;
+	}
+
 	if (new_mtu != oldmtu) {
 		spin_lock_irqsave(&vptr->lock, flags);
 

-- 
