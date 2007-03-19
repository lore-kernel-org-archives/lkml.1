Return-Path: <linux-kernel-owner+w=401wt.eu-S1030653AbXCSVqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030653AbXCSVqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030678AbXCSVpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:45:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59420 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030634AbXCSVmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:42:32 -0400
Date: Mon, 19 Mar 2007 14:40:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       Guennadi Liakhovetski <gl@dsa-ac.de>, irda-users@lists.sourceforge.net,
       Samuel Ortiz <samuel@sortiz.org>
Subject: [patch 24/31] IrDA: irttp_dup spin_lock initialisation
Message-ID: <20070319214032.GZ9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="irda-irttp_dup-spin_lock-initialisation.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Samuel Ortiz <samuel@sortiz.org>

Without this initialization one gets

kernel BUG at kernel/rtmutex_common.h:80!

This patch should also be included in the -stable kernel.

Signed-off-by: G. Liakhovetski <gl@dsa-ac.de>
Signed-off-by: Samuel Ortiz <samuel@sortiz.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/irda/irttp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/irda/irttp.c
+++ b/net/irda/irttp.c
@@ -1455,6 +1455,7 @@ struct tsap_cb *irttp_dup(struct tsap_cb
 
 	/* Not everything should be copied */
 	new->notify.instance = instance;
+	spin_lock_init(&new->lock);
 	init_timer(&new->todo_timer);
 
 	skb_queue_head_init(&new->rx_queue);

-- 
