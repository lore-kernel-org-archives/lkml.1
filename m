Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbZKXJNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbZKXJNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932388AbZKXJNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:13:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbZKXJNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:13:41 -0500
Date: Tue, 24 Nov 2009 10:13:47 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?ISO-8859-15?Q?=22Andr=E9_Goddard_Rosa=22?= 
	<andre.goddard@gmail.com>,
       Bruce Allan <bruce.w.allan@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the trivial tree with the net tree
In-Reply-To: <20091124171459.88cb0c0d.sfr@canb.auug.org.au>
Message-ID: <alpine.LSU.2.00.0911241011520.6953@wotan.suse.de>
References: <20091124171459.88cb0c0d.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> drivers/net/e1000e/lib.c between commit
> 3bb99fe226ead584a4db674dab546689f705201f ("e1000e: consolidate two dbug
> macros into one simpler one") from the net tree and commit
> 52692d35d013e221137b2fbe800e3e6776111821 ("tree-wide: fix assorted typos
> all over the place") from the trivial tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/net/e1000e/lib.c
> index f690a10,b065ba4..0000000
> --- a/drivers/net/e1000e/lib.c
> +++ b/drivers/net/e1000e/lib.c
> @@@ -563,11 -570,11 +563,11 @@@ s32 e1000e_check_for_serdes_link(struc
>   			if (rxcw & E1000_RXCW_SYNCH) {
>   				if (!(rxcw & E1000_RXCW_IV)) {
>   					mac->serdes_has_link = true;
>  -					hw_dbg(hw, "SERDES: Link up - autoneg "
>  +					e_dbg("SERDES: Link up - autoneg "
> - 					   "completed sucessfully.\n");
> + 					   "completed successfully.\n");
>   				} else {
>   					mac->serdes_has_link = false;
>  -					hw_dbg(hw, "SERDES: Link down - invalid"
>  +					e_dbg("SERDES: Link down - invalid"
>   					   "codewords detected in autoneg.\n");
>   				}
>   			} else {

Maybe the best resolution would be for Davem to merge the respective hunk 
through his tree, so that I can drop it on my side. Please let me know 
if/when this, I will drop the hunk then.


From: André Goddard Rosa <andre.goddard@gmail.com>
Subject: e1000e: fix assorted typos

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -282,7 +282,7 @@ static s32 e1000_init_mac_params_82571(struct e1000_adapter *adapter)
 
 	/*
 	 * Ensure that the inter-port SWSM.SMBI lock bit is clear before
-	 * first NVM or PHY acess. This should be done for single-port
+	 * first NVM or PHY access. This should be done for single-port
 	 * devices, and for one port only on dual-port devices so that
 	 * for those devices we can still use the SMBI lock to synchronize
 	 * inter-port accesses to the PHY & NVM.
@@ -1412,7 +1412,7 @@ static s32 e1000_check_for_serdes_link_82571(struct e1000_hw *hw)
 		case e1000_serdes_link_autoneg_progress:
 			/*
 			 * If the LU bit is set in the STATUS register,
-			 * autoneg has completed sucessfully. If not,
+			 * autoneg has completed successfully. If not,
 			 * try foring the link because the far end may be
 			 * available but not capable of autonegotiation.
 			 */
diff --git a/drivers/net/e1000e/lib.c b/drivers/net/e1000e/lib.c
index 99ba2b8..b065ba4 100644
--- a/drivers/net/e1000e/lib.c
+++ b/drivers/net/e1000e/lib.c
@@ -571,7 +571,7 @@ s32 e1000e_check_for_serdes_link(struct e1000_hw *hw)
 				if (!(rxcw & E1000_RXCW_IV)) {
 					mac->serdes_has_link = true;
 					hw_dbg(hw, "SERDES: Link up - autoneg "
-					   "completed sucessfully.\n");
+					   "completed successfully.\n");
 				} else {
 					mac->serdes_has_link = false;
 					hw_dbg(hw, "SERDES: Link down - invalid"

