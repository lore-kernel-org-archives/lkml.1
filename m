Return-Path: <linux-kernel-owner+w=401wt.eu-S932430AbZJPRVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbZJPRVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756321AbZJPRVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:21:36 -0400
Received: from kroah.org ([198.145.64.141]:48642 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbZJPRSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:40 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:05 2009
Message-Id: <20091016171204.994775310@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexander Duyck <alexander.h.duyck@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Tim Gardner <tim.gardner@canonical.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [35/46] e1000e: swap max hw supported frame size between 82574 and 82583
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=e1000e-swap-max-hw-supported-frame-size-between-82574-and-82583.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alexander Duyck <alexander.h.duyck@intel.com>

commit a825e00c98a2ee37eb2a0ad93b352e79d2bc1593 upstream.

There appears to have been a mixup in the max supported jumbo frame size
between 82574 and 82583 which ended up disabling jumbo frames on the 82574
as a result.  This patch swaps the two so that this issue is resolved.

This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=14261

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -1803,7 +1803,7 @@ struct e1000_info e1000_82574_info = {
 				  | FLAG_HAS_AMT
 				  | FLAG_HAS_CTRLEXT_ON_LOAD,
 	.pba			= 20,
-	.max_hw_frame_size	= ETH_FRAME_LEN + ETH_FCS_LEN,
+	.max_hw_frame_size	= DEFAULT_JUMBO,
 	.get_variants		= e1000_get_variants_82571,
 	.mac_ops		= &e82571_mac_ops,
 	.phy_ops		= &e82_phy_ops_bm,
@@ -1820,7 +1820,7 @@ struct e1000_info e1000_82583_info = {
 				  | FLAG_HAS_AMT
 				  | FLAG_HAS_CTRLEXT_ON_LOAD,
 	.pba			= 20,
-	.max_hw_frame_size	= DEFAULT_JUMBO,
+	.max_hw_frame_size	= ETH_FRAME_LEN + ETH_FCS_LEN,
 	.get_variants		= e1000_get_variants_82571,
 	.mac_ops		= &e82571_mac_ops,
 	.phy_ops		= &e82_phy_ops_bm,


