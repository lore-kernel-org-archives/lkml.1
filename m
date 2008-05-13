Return-Path: <linux-kernel-owner+w=401wt.eu-S1763813AbYEMUYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763813AbYEMUYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbYEMUQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:16:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:38790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217AbYEMUQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:16:21 -0400
Date: Tue, 13 May 2008 13:12:40 -0700
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
       Ivan Vecera <ivecera@redhat.com>,
       Francois Romieu <romieu@fr.zoreil.com>
Subject: [patch 30/37] r8169: fix oops in r8169_get_mac_version
Message-ID: <20080513201240.GE31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="r8169-fix-oops-in-r8169_get_mac_version.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ivan Vecera <ivecera@redhat.com>

commit 21e197f231343201368338603cb0909a13961bac upstream.

r8169_get_mac_version crashes when it meets an unknown MAC
due to tp->pci_dev not being set. Initialize it early.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/r8169.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1617,6 +1617,7 @@ rtl8169_init_one(struct pci_dev *pdev, c
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	tp = netdev_priv(dev);
 	tp->dev = dev;
+	tp->pci_dev = pdev;
 	tp->msg_enable = netif_msg_init(debug.msg_enable, R8169_MSG_DEFAULT);
 
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
@@ -1777,7 +1778,6 @@ rtl8169_init_one(struct pci_dev *pdev, c
 #endif
 
 	tp->intr_mask = 0xffff;
-	tp->pci_dev = pdev;
 	tp->mmio_addr = ioaddr;
 	tp->align = cfg->align;
 	tp->hw_start = cfg->hw_start;

-- 
