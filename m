Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535Ab0AZX6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab0AZX6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505Ab0AZX6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:58:17 -0500
Received: from kroah.org ([198.145.64.141]:35298 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab0AZXng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:36 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:26 2010
Message-Id: <20100126233926.539330531@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [43/98] [SCSI] fcoe: remove redundant checking of netdev->netdev_ops
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yi Zou <yi.zou@intel.com>

commit b04d023cf5b7f4113cc4a09405c2fe8003bfe37d upstream.

Remove the redundant checking of netdev->netdev_ops as it will never be NULL.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/fcoe/fcoe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -664,7 +664,7 @@ static int fcoe_ddp_setup(struct fc_lpor
 {
 	struct net_device *n = fcoe_netdev(lp);
 
-	if (n->netdev_ops && n->netdev_ops->ndo_fcoe_ddp_setup)
+	if (n->netdev_ops->ndo_fcoe_ddp_setup)
 		return n->netdev_ops->ndo_fcoe_ddp_setup(n, xid, sgl, sgc);
 
 	return 0;
@@ -681,7 +681,7 @@ static int fcoe_ddp_done(struct fc_lport
 {
 	struct net_device *n = fcoe_netdev(lp);
 
-	if (n->netdev_ops && n->netdev_ops->ndo_fcoe_ddp_done)
+	if (n->netdev_ops->ndo_fcoe_ddp_done)
 		return n->netdev_ops->ndo_fcoe_ddp_done(n, xid);
 	return 0;
 }


