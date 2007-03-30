Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXC3VX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXC3VX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 17:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbXC3VWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 17:22:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58284 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbXC3VKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 17:10:25 -0400
Date: Fri, 30 Mar 2007 14:04:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "G. Liakhovetski" <gl@dsa-ac.de>, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 13/37] PPP: Fix PPP skb leak
Message-ID: <20070330210438.GO29450@kroah.com>
References: <20070330205938.984247529@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ppp-fix-ppp-skb-leak.patch"
In-Reply-To: <20070330210334.GA29450@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: G. Liakhovetski <gl@dsa-ac.de>

[PPP]: Don't leak an sk_buff on interface destruction.

Signed-off-by: G. Liakhovetski <gl@dsa-ac.de>
Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ppp_generic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ppp_generic.c
+++ b/drivers/net/ppp_generic.c
@@ -2544,6 +2544,9 @@ static void ppp_destroy_interface(struct
 	ppp->active_filter = NULL;
 #endif /* CONFIG_PPP_FILTER */
 
+	if (ppp->xmit_pending)
+		kfree_skb(ppp->xmit_pending);
+
 	kfree(ppp);
 }
 

-- 
