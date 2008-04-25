Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbYDYAqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbYDYAqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 20:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYDYAqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 20:46:16 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:46452 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbYDYAqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 20:46:15 -0400
Message-ID: <4811299A.7060407@tiscali.nl>
Date: Fri, 25 Apr 2008 02:45:14 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: mcgrof@gmail.com, linux-wireless@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] prism54: prism54_get_encode() test below 0 on unsigned
 index
References: <480F9481.2040303@tiscali.nl> <1209056973.5224.0.camel@localhost.localdomain>
In-Reply-To: <1209056973.5224.0.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> On Wed, 2008-04-23 at 21:56 +0200, Roel Kluin wrote:

>> u32 index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
> 
> Probably should just change that to an 'int' instead of a u32.
> 
> Dan
> 

Thanks, in that case use the patch below
---
when left unsigned, the test 'if (index < 0)' will not work.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
index e5b3c28..8076ead 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1158,7 +1158,8 @@ prism54_get_encode(struct net_device *ndev, struct iw_request_info *info,
 {
 	islpci_private *priv = netdev_priv(ndev);
 	struct obj_key *key;
-	u32 devindex, index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
+	u32 devindex;
+	int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
 	u32 authen = 0, invoke = 0, exunencrypt = 0;
 	int rvalue;
 	union oid_res_t r;

