Return-Path: <linux-kernel-owner+w=401wt.eu-S1763356AbYBBOxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763356AbYBBOxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 09:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758163AbYBBOxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 09:53:06 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:42257 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758108AbYBBOxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 09:53:04 -0500
Date: Sat, 2 Feb 2008 15:34:58 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jgarzik@pobox.com, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] sis190: fix compile error section type conflict
Message-ID: <20080202143458.GA27978@electric-eye.fr.zoreil.com>
References: <47A3FF3F.1040908@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A3FF3F.1040908@cn.fujitsu.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan <lizf@cn.fujitsu.com> :
> Fix the following compile error:

I am not sure that it is the right fix. Please read the archive of
this week on l-k.

I'll submit the patch below to Jeff once I have tested it with real
hardware (sunday evening entertainment). Sam, is it ok to add your
s-o-b to it ?

Subject: [PATCH] sis190: fix section type conflict

The driver already contains __devinitdata which is not const.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Michael D. Setzer II <mikes@kuentos.guam.net>
Cc: Gabriel C <nix.or.die@googlemail.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/net/sis190.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sis190.c b/drivers/net/sis190.c
index b570402..0a5e024 100644
--- a/drivers/net/sis190.c
+++ b/drivers/net/sis190.c
@@ -1556,7 +1556,7 @@ static int __devinit sis190_get_mac_addr_from_eeprom(struct pci_dev *pdev,
 static int __devinit sis190_get_mac_addr_from_apc(struct pci_dev *pdev,
 						  struct net_device *dev)
 {
-	static const u16 __devinitdata ids[] = { 0x0965, 0x0966, 0x0968 };
+	static const u16 __devinitconst ids[] = { 0x0965, 0x0966, 0x0968 };
 	struct sis190_private *tp = netdev_priv(dev);
 	struct pci_dev *isa_bridge;
 	u8 reg, tmp8;
-- 
1.5.3.3


