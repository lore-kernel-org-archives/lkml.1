Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbYF0R7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbYF0R7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbYF0R7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:59:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:63388 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbYF0R7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:59:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,716,1204531200"; 
   d="scan'208";a="402844334"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [NET-NEXT PATCH 01/18] igb: limit EEPROM access
To: jeff@garzik.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Date: Fri, 27 Jun 2008 10:59:33 -0700
Message-ID: <20080627175921.22428.52767.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2008 17:59:36.0705 (UTC) FILETIME=[8FEB0710:01C8D87F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EEPROM access beyond the base eeprom page is unsupported.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
---

 drivers/net/igb/e1000_82575.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/igb/e1000_82575.c b/drivers/net/igb/e1000_82575.c
index cda3ec8..39d44dc 100644
--- a/drivers/net/igb/e1000_82575.c
+++ b/drivers/net/igb/e1000_82575.c
@@ -171,6 +171,10 @@ static s32 igb_get_invariants_82575(struct e1000_hw *hw)
 	 * for setting word_size.
 	 */
 	size += NVM_WORD_SIZE_BASE_SHIFT;
+
+	/* EEPROM access above 16k is unsupported */
+	if (size > 14)
+		size = 14;
 	nvm->word_size = 1 << size;
 
 	/* setup PHY parameters */

