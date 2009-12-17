Return-Path: <linux-kernel-owner+w=401wt.eu-S1763746AbZLQBVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763746AbZLQBVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763649AbZLQBUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:38 -0500
Received: from kroah.org ([198.145.64.141]:47976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763606AbZLQBUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:30 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:04 2009
Message-Id: <20091217011603.954645418@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [46/90] slc90e66: fix UDMA handling
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

[ Upstream commit ee31527a02b0a8e1aa4a5e4084d2db5fa34737ed ]

Fix checking of the currently programmed UDMA mode.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/slc90e66.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/ide/slc90e66.c
+++ b/drivers/ide/slc90e66.c
@@ -91,8 +91,7 @@ static void slc90e66_set_dma_mode(ide_dr
 
 		if (!(reg48 & u_flag))
 			pci_write_config_word(dev, 0x48, reg48|u_flag);
-		/* FIXME: (reg4a & a_speed) ? */
-		if ((reg4a & u_speed) != u_speed) {
+		if ((reg4a & a_speed) != u_speed) {
 			pci_write_config_word(dev, 0x4a, reg4a & ~a_speed);
 			pci_read_config_word(dev, 0x4a, &reg4a);
 			pci_write_config_word(dev, 0x4a, reg4a|u_speed);


