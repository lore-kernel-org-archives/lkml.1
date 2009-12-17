Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbZLQEXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbZLQEXG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935976AbZLQEWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:22:04 -0500
Received: from kroah.org ([198.145.64.141]:55827 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935712AbZLQEFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:07 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:56 2009
Message-Id: <20091217035656.868210204@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [107/151] slc90e66: fix UDMA handling
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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


