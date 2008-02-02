Return-Path: <linux-kernel-owner+w=401wt.eu-S1764181AbYBBAbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764181AbYBBAbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762901AbYBBAZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:25:10 -0500
Received: from ns1.suse.de ([195.135.220.2]:54677 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763492AbYBBAZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:25:07 -0500
Date: Fri, 1 Feb 2008 16:20:54 -0800
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
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 19/27] CASSINI: Set skb->truesize properly on receive
	packets.
Message-ID: <20080202002054.GT8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cassini_3.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David Miller <davem@davemloft.net>

[ Upstream commit: d011a231675b240157a3c335dd53e9b849d7d30d ]

skb->truesize was not being incremented at all to
reflect the page based data added to RX SKBs.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cassini.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -2037,6 +2037,7 @@ static int cas_rx_process_pkt(struct cas
 
 		skb_shinfo(skb)->nr_frags++;
 		skb->data_len += hlen - swivel;
+		skb->truesize += hlen - swivel;
 		skb->len      += hlen - swivel;
 
 		get_page(page->buffer);

-- 
