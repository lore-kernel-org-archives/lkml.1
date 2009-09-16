Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbZIPWgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbZIPWgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760219AbZIPWfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:35:51 -0400
Received: from kroah.org ([198.145.64.141]:40993 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760135AbZIPWcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:29:04 2009
Message-Id: <20090916222904.712761455@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:28:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 23/24] PCI: Unhide the SMBus on the Compaq Evo D510 USDT
References: <20090916222819.244332644@mini.kroah.org>
Content-Disposition: inline; filename=pci-unhide-the-smbus-on-the-compaq-evo-d510-usdt.patch
In-Reply-To: <20090916222934.GA31846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit 6b5096e4d4496e185cd1ada5d1b8e1d941c805ed upstream.

One more form factor for Compaq Evo D510, which needs the same quirk
as the other form factors. Apparently there's no hardware monitoring
chip on that one, but SPD EEPROMs, so it's still worth unhiding the
SMBus.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Nuzhna Pomoshch <nuzhna_pomoshch@yahoo.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1201,6 +1201,7 @@ static void __init asus_hides_smbus_hostbridge(struct pci_dev *dev)
 			switch(dev->subsystem_device) {
 			case 0x00b8: /* Compaq Evo D510 CMT */
 			case 0x00b9: /* Compaq Evo D510 SFF */
+			case 0x00ba: /* Compaq Evo D510 USDT */
 				/* Motherboard doesn't have Host bridge
 				 * subvendor/subdevice IDs and on-board VGA
 				 * controller is disabled if an AGP card is


