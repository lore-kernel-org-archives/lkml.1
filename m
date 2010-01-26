Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432Ab0AZXx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab0AZXx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282Ab0AZXxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:53:39 -0500
Received: from kroah.org ([198.145.64.141]:35376 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680Ab0AZXnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:51 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:28 2010
Message-Id: <20100126233928.503055595@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ron Mercer <ron.mercer@qlogic.com>,
       "David S. Miller" <davem@davemloft.net>,
       Brandon Philips <bphilips@suse.de>
Subject: [58/98] qlge: Bonding fix for mode 6.
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ron Mercer <ron.mercer@qlogic.com>

commit 63ae93a19094d88c8ca62543586b20e3a7ff7637 upstream.

Allow MAC address to be changed even if device is not up.

Signed-off-by: Ron Mercer <ron.mercer@qlogic.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Brandon Philips <bphilips@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/qlge/qlge_main.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -3712,9 +3712,6 @@ static int qlge_set_mac_address(struct n
 	struct sockaddr *addr = p;
 	int status;
 
-	if (netif_running(ndev))
-		return -EBUSY;
-
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 	memcpy(ndev->dev_addr, addr->sa_data, ndev->addr_len);


