Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500Ab0AZXn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0AZXn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639Ab0AZXnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:47 -0500
Received: from kroah.org ([198.145.64.141]:35349 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab0AZXno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:44 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:27 2010
Message-Id: <20100126233927.712571685@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [52/98] [SCSI] fcoe: Fix checking san mac address
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yi Zou <yi.zou@intel.com>

commit bf361707c81f8e8e43e332bfc8838bae76ae021a upstream.

This was fixed before in 7a7f0c7 but it's introduced again recently.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -176,7 +176,7 @@ static int fcoe_interface_setup(struct f
 	rcu_read_lock();
 	for_each_dev_addr(netdev, ha) {
 		if ((ha->type == NETDEV_HW_ADDR_T_SAN) &&
-		    (is_valid_ether_addr(fip->ctl_src_addr))) {
+		    (is_valid_ether_addr(ha->addr))) {
 			memcpy(fip->ctl_src_addr, ha->addr, ETH_ALEN);
 			fip->spma = 1;
 			break;


