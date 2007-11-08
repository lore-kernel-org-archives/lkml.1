Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbXKHAVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbXKHAVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXKHAVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:21:31 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:35651 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752336AbXKHAVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:21:30 -0500
Date: Thu, 8 Nov 2007 01:21:12 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] r8169 fix regression on ASUS motherboards (updated)
Message-ID: <20071108002112.GD15367@electric-eye.fr.zoreil.com>
References: <4731E2AB.5080703@rtr.ca> <4731FDB7.8010505@rtr.ca> <20071107220455.GA15367@electric-eye.fr.zoreil.com> <47323A69.5050206@rtr.ca> <47323B6B.9000909@rtr.ca> <47324843.4050602@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47324843.4050602@rtr.ca>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord <lkml@rtr.ca> :
[...]
> I've now received a couple of private emails from people reporting
> full success with this patch.

Ok, I have pushed the patch below for Jeff to pull at korg.

>From 1dd7681bc2ff171341ea5cae957f8ecb5c0c102e Mon Sep 17 00:00:00 2001
From: Mark Lord <mlord@pobox.com>
Date: Thu, 8 Nov 2007 01:03:04 +0100
Subject: [PATCH] r8169: revert 7da97ec96a0934319c7fbedd3d38baf533e20640 (partly)

Various symptoms depending on the .config options:
- the card stops working after some (short) time
- the card does not work at all
- the card disappears (nothing in lspci/dmesg)

A real power-off is needed to recover the card.

Signed-off-by: Mark Lord <mlord@pobox.com>
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/net/r8169.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 9dbab3f..a37cf82 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1328,6 +1328,7 @@ static void rtl_hw_phy_config(struct net_device *dev)
 		break;
 	case RTL_GIGA_MAC_VER_11:
 	case RTL_GIGA_MAC_VER_12:
+		break;
 	case RTL_GIGA_MAC_VER_17:
 		rtl8168b_hw_phy_config(ioaddr);
 		break;
-- 
1.5.3.3

-- 
Ueimor
