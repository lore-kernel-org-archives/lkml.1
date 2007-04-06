Return-Path: <linux-kernel-owner+w=401wt.eu-S1750799AbXDFEBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750799AbXDFEBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 00:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbXDFEBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 00:01:09 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:33728 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbXDFEBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 00:01:07 -0400
X-IronPort-AV: i="4.14,381,1170651600"; 
   d="scan'208"; a="33931651:sNHT28194593"
Subject: [PATCH] USB gadget rndis: fix struct rndis_packet_msg_type
	unaligned bug
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Brownell <david-b@pacbell.net>, jie.zhang@analog.com,
       roy.huang@analog.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, bryan.wu@analog.com
In-Reply-To: <1175826318.17315.57.camel@roc-desktop>
References: <1175668113.10608.41.camel@roc-desktop>
	 <200704051429.04147.david-b@pacbell.net>
	 <1175826318.17315.57.camel@roc-desktop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 06 Apr 2007 12:02:49 +0800
Message-Id: <1175832169.17315.61.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] usb gadget rndis: 
skb_push function may return a pointer which is not aligned as required
by struct rndis_packet_msg_type. Using attribute trick to fix this bug.

Signed-off-by: Roy Huang <roy.huang@analog.com>
Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/usb/gadget/rndis.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/rndis.h b/drivers/usb/gadget/rndis.h
index 4c3c725..397b149 100644
--- a/drivers/usb/gadget/rndis.h
+++ b/drivers/usb/gadget/rndis.h
@@ -195,7 +195,7 @@ struct rndis_packet_msg_type
 	__le32	PerPacketInfoLength;
 	__le32	VcHandle;
 	__le32	Reserved;
-};
+} __attribute__ ((packed));
 
 struct rndis_config_parameter
 {
-- 
1.5.0.5

