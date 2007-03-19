Return-Path: <linux-kernel-owner+w=401wt.eu-S1030682AbXCSVpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030682AbXCSVpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030649AbXCSVmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:42:32 -0400
Received: from cantor.suse.de ([195.135.220.2]:55861 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030636AbXCSVmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:42:00 -0400
Date: Mon, 19 Mar 2007 14:40:11 -0700
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
       Alexey Dobriyan <adobriyan@sw.ru>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 21/31] Copy over mac_len when cloning an skb
Message-ID: <20070319214011.GW9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="copy-over-mac_len-when-cloning-an-skb.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Alexey Dobriyan <adobriyan@sw.ru>

[NET]: Copy mac_len in skb_clone() as well

ANK says: "It is rarely used, that's wy it was not noticed.
But in the places, where it is used, it should be disaster."

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/skbuff.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -464,6 +464,7 @@ struct sk_buff *skb_clone(struct sk_buff
 	memcpy(n->cb, skb->cb, sizeof(skb->cb));
 	C(len);
 	C(data_len);
+	C(mac_len);
 	C(csum);
 	C(local_df);
 	n->cloned = 1;

-- 
