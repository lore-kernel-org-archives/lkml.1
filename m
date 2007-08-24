Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbXHXFVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbXHXFVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 01:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbXHXFVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 01:21:22 -0400
Received: from 1wt.eu ([62.212.114.60]:2291 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbXHXFVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 01:21:21 -0400
Date: Fri, 24 Aug 2007 07:06:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Mr. Berkley Shands" <bshands@exegy.com>
Cc: linux-kernel@vger.kernel.org, Net Dev <netdev@vger.kernel.org>
Subject: Re: 2.6.22.5 forcedeth timeout hang
Message-ID: <20070824050617.GS6002@1wt.eu>
References: <46CE1CC7.6000507@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CE1CC7.6000507@exegy.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 06:48:23PM -0500, Mr. Berkley Shands wrote:
> 100% reproducible hang on xmit timeout.
> Just do a "make -j4 modules" on an nfs mounted kernel source.

Most likely you also had the problem with 2.6.22.2 (maybe you have not
tested this one, though). There were bug fixes for forcedeth introduced
in this version, one of them being buggy. The patch below fixes it. Can
you please give it a try ? If it does not fix the problem, please try
2.6.22.1 which does not include those changes. I'm interested because
I have those changes pending for 2.6.20.17 too.

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 10f4e3b..1938d6d 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -552,7 +552,7 @@ union ring_type {
 #define PHY_OUI_MARVELL	0x5043
 #define PHY_OUI_CICADA	0x03f1
 #define PHY_OUI_VITESSE	0x01c1
-#define PHY_OUI_REALTEK	0x01c1
+#define PHY_OUI_REALTEK	0x0732
 #define PHYID1_OUI_MASK	0x03ff
 #define PHYID1_OUI_SHFT	6
 #define PHYID2_OUI_MASK	0xfc00

Thanks,
Willy

