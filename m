Return-Path: <linux-kernel-owner+w=401wt.eu-S1763038AbYFNASm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763038AbYFNASm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760547AbYFNANq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:13:46 -0400
Received: from mx1.suse.de ([195.135.220.2]:34343 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760754AbYFNANo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:13:44 -0400
Date: Fri, 13 Jun 2008 17:11:13 -0700
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
       alan@lxorguk.ukuu.org.uk, David Woodhouse <dwmw2@infradead.org>,
       "David S. Miller" <davem@davemloft.net>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 19/47] net: Fix call to ->change_rx_flags(dev,
	IFF_MULTICAST) in dev_change_flags()
Message-ID: <20080614001113.GS24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-fix-call-to-change_rx_flags-in-dev_change_flags.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Woodhouse <dwmw2@infradead.org>

[ upstream commit: 0e91796eb46e29edc791131c832a2232bcaed9dd ]

Am I just being particularly dim today, or can the call to
dev->change_rx_flags(dev, IFF_MULTICAST) in dev_change_flags() never
happen?

We've just set dev->flags = flags & IFF_MULTICAST, effectively. So the
condition '(dev->flags ^ flags) & IFF_MULTICAST' is _never_ going to be
true.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 net/core/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3132,7 +3132,7 @@ int dev_change_flags(struct net_device *
 	 *	Load in the correct multicast list now the flags have changed.
 	 */
 
-	if (dev->change_rx_flags && (dev->flags ^ flags) & IFF_MULTICAST)
+	if (dev->change_rx_flags && (old_flags ^ flags) & IFF_MULTICAST)
 		dev->change_rx_flags(dev, IFF_MULTICAST);
 
 	dev_set_rx_mode(dev);

-- 
