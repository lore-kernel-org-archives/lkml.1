Return-Path: <linux-kernel-owner+w=401wt.eu-S1761934AbZJIXnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934AbZJIXnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761694AbZJIXmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:42:52 -0400
Received: from kroah.org ([198.145.64.141]:51486 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761619AbZJIXmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:42:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:34:40 2009
Message-Id: <20091009233440.284809932@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:34:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike McCormack <mikem@ring3k.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 33/37] sky2: Set SKY2_HW_RAM_BUFFER in sky2_init
References: <20091009233411.852013234@mini.kroah.org>
Content-Disposition: inline; filename=sky2-set-sky2_hw_ram_buffer-in-sky2_init.patch
In-Reply-To: <20091009233812.GA15982@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mike McCormack <mikem@ring3k.org>

[ Upstream commit 74a61ebf653c6abe459f228eb40e9f24f7ef1fb7 ]

The SKY2_HW_RAM_BUFFER bit in hw->flags was checked in sky2_mac_init(),
 before being set later in sky2_up().

Setting SKY2_HW_RAM_BUFFER in sky2_init() where other hw->flags are set
 should avoid this problem recurring.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
Acked-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/sky2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -1455,7 +1455,6 @@ static int sky2_up(struct net_device *de
 	if (ramsize > 0) {
 		u32 rxspace;
 
-		hw->flags |= SKY2_HW_RAM_BUFFER;
 		pr_debug(PFX "%s: ram buffer %dK\n", dev->name, ramsize);
 		if (ramsize < 16)
 			rxspace = ramsize / 2;
@@ -2942,6 +2941,9 @@ static int __devinit sky2_init(struct sk
 			++hw->ports;
 	}
 
+	if (sky2_read8(hw, B2_E_0))
+		hw->flags |= SKY2_HW_RAM_BUFFER;
+
 	return 0;
 }
 


