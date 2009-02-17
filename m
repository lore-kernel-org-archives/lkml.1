Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbZBQLnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbZBQLnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZBQLnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:43:31 -0500
Received: from titan.dewahost.net ([205.234.111.6]:48627 "EHLO
	titan.dewahost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZBQLna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:43:30 -0500
Date: Tue, 17 Feb 2009 15:43:23 +0400
From: Constantin Baranov <baranov@mercdev.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] niu: fix PHY template choice for 10G copper
Message-Id: <20090217154323.580fcb2f.baranov@mercdev.com>
Organization: Mercury Development, LLC
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - titan.dewahost.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mercdev.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a typo in niu_determine_phy_disposition() which resulted in
phy_template_1g_copper being selected for 10G/copper configuration.

Signed-off-by: Constantin Baranov <baranov@mercdev.com>
---
While working on support of link speed setting I discovered this piece
of code which seemed pretty strange to me. I believe this to be just a
typo. With its current state the code for 10G/copper card initialization
will likely be broken by the second patch alone (as it changes the way
the 1G card is initialized), this is why I'm submitting these two
patches together. I was unable to find any 10G/copper Neptune cards
available for testing, so I'm asking for the help of the community.

Can anyone on the list confirm that the current driver works for
10G/copper? This would be much appreciated.

David, could you please clarify which is the correct way to initialize
10G/copper card? If I'm wrong, and 1G code must really work with 10G
cards, could you please describe which would be the best way to separate
1G and 10G branches in the xcvr_init_1g() and link_status_1g() routines?

 drivers/net/niu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 0c0b752..15c9e5f 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -2456,7 +2456,7 @@ static int niu_determine_phy_disposition(struct niu *np)
 
 		case NIU_FLAGS_10G:
 			/* 10G copper */
-			tp = &phy_template_1g_copper;
+			tp = &phy_template_10g_copper;
 			break;
 
 		case NIU_FLAGS_FIBER:
-- 
1.6.0.6

