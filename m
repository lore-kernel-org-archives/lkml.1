Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYIWWqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYIWWqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 18:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYIWWqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 18:46:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:50844 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbYIWWqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 18:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding:sender;
        b=TInqTiQGRLjN9M+5Hma7OdXiDkRtud2ipXqO/WAIhtBJLwuwGRhGh4nfF1698Na5u/
         youCsWgduVNIUkplCwgTqp39Qyl9q6DgfcV2qGh3XnMechBDykAP0vvRW2LzMM7SDyIH
         XwaNxv5NRzSOEaPEJ7GMWKLrnWtlYZnX+dwLA=
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 3/3] e1000e: remove failed request for sw/fw/hw flag
To: jeff@garzik.org, mingo@elte.hu, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com, john.ronciak@intel.com,
       Bruce Allan <bruce.w.allan@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 23 Sep 2008 15:46:38 -0700
Message-ID: <20080923224630.6927.28967.stgit@jtkirshe-mobile.jf.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

When the driver fails to acquire the control flag used to serialize
NVM and PHY accesses between the driver, firmware and hardware, remove the
request for the flag otherwise the hardware might grant the flag when it
becomes available but the driver will not release the flag.  This could
cause the firmware to prevent the driver getting the flag for all future
attempts.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 drivers/net/e1000e/ich8lan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index f47c60e..6b14ea8 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -409,6 +409,8 @@ static s32 e1000_acquire_swflag_ich8lan(struct e1000_hw *hw)
 
 	if (!timeout) {
 		hw_dbg(hw, "FW or HW has locked the resource for too long.\n");
+		extcnf_ctrl &= ~E1000_EXTCNF_CTRL_SWFLAG;
+		ew32(EXTCNF_CTRL, extcnf_ctrl);
 		return -E1000_ERR_CONFIG;
 	}
 

