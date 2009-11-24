Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbZKXDLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbZKXDLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 22:11:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbZKXDLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 22:11:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58098 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757740AbZKXDLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 22:11:18 -0500
Date: Tue, 24 Nov 2009 14:11:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bruce Allan <bruce.w.allan@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20091124141122.63e81c55.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/e1000e/ich8lan.c between commit
818f33313caab9be2a10458500dbed4a88c1b334 ("e1000e: do not initiate
autonegotiation during OEM configuration") from the net-current tree and
commit 94d8186a693284344ee5cb9734086c7a2370241a ("e1000e: cleanup ops
function pointers") from the net tree.

Just context changes. I fixed it up (see below) and can carry the fix for
a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/e1000e/ich8lan.c
index eff3f47,568bb25..0000000
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@@ -1118,12 -1110,11 +1110,12 @@@ static s32 e1000_oem_bits_config_ich8la
  			oem_reg |= HV_OEM_BITS_LPLU;
  	}
  	/* Restart auto-neg to activate the bits */
 -	oem_reg |= HV_OEM_BITS_RESTART_AN;
 +	if (!e1000_check_reset_block(hw))
 +		oem_reg |= HV_OEM_BITS_RESTART_AN;
- 	ret_val = hw->phy.ops.write_phy_reg_locked(hw, HV_OEM_BITS, oem_reg);
+ 	ret_val = hw->phy.ops.write_reg_locked(hw, HV_OEM_BITS, oem_reg);
  
  out:
- 	hw->phy.ops.release_phy(hw);
+ 	hw->phy.ops.release(hw);
  
  	return ret_val;
  }
