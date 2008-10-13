Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbYJMXNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbYJMXNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 19:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbYJMXMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 19:12:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53410
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756094AbYJMXMw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 19:12:52 -0400
Date: Mon, 13 Oct 2008 16:12:28 -0700 (PDT)
Message-Id: <20081013.161228.74135367.davem@davemloft.net>
To: jamagallon@ono.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.27-git3: rtl8169 oops and wireless missing symbols
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081014010202.71d13eaf@werewolf.home>
References: <20081014010202.71d13eaf@werewolf.home>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J.A. Magallón" <jamagallon@ono.com>
Date: Tue, 14 Oct 2008 01:02:02 +0200

> Booting .27-git3 on the Aspire One gave me a couple oopses.

Fixed by:

commit 738e1e694bf6d9e965ba0ce2667a1bec5780a172
Author: Petr Vandrovec <petr@vandrovec.name>
Date:   Sun Oct 12 20:58:29 2008 -0700

    r8169: NULL pointer dereference on r8169 load
    
    mmio_addr in r8169 needs to be initialized before use
    
    Maybe that all tp-> initialization should be moved before rtl_init_mac_address call,
    but this is enough to get rid of crash in rtl_rar_set due to mmio_addr being uninitialized.
    
    Signed-off-by: Petr Vandrovec <petr@vandrovec.name>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index bdae2c5..c821da2 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2154,6 +2154,8 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	spin_lock_init(&tp->lock);
 
+	tp->mmio_addr = ioaddr;
+
 	rtl_init_mac_address(tp, ioaddr);
 
 	/* Get MAC address */
@@ -2186,7 +2188,6 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 
 	tp->intr_mask = 0xffff;
-	tp->mmio_addr = ioaddr;
 	tp->align = cfg->align;
 	tp->hw_start = cfg->hw_start;
 	tp->intr_event = cfg->intr_event;
