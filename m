Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbZLDWjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbZLDWjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZLDWjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:39:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:37939 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbZLDWjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:39:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,344,1257148800"; 
   d="scan'208";a="519918297"
Date: Fri, 4 Dec 2009 14:39:44 -0800 (Pacific Standard Time)
From: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
To: Emese Revfy <re.emese@gmail.com>
cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 06/31] Constify struct e1000_mac_operations for 2.6.32
 v1
In-Reply-To: <4B198A33.7080705@gmail.com>
Message-ID: <Pine.WNT.4.64.0912041437590.5228@ppwaskie-MOBL2.amr.corp.intel.com>
References: <4B198670.2000406@gmail.com> <4B198A33.7080705@gmail.com>
ReplyTo: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
X-X-Sender: amrppwaskie@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Emese Revfy wrote:

> From: Emese Revfy <re.emese@gmail.com>
> 
> Constify struct e1000_mac_operations with some exceptions.
> 
> Signed-off-by: Emese Revfy <re.emese@gmail.com>

Any networking patches need to be sent to the netdev list and Dave Miller.  
I've added those to the CC, and will do the same for the other two e1000 
patches in your series.

Cheers,
-PJ

> ---
>  drivers/net/e1000e/82571.c    |    3 ++-
>  drivers/net/e1000e/e1000.h    |    2 +-
>  drivers/net/e1000e/es2lan.c   |    3 ++-
>  drivers/net/e1000e/ich8lan.c  |    2 +-
>  drivers/net/igb/e1000_82575.c |    2 +-
>  drivers/net/igb/e1000_hw.h    |    2 +-
>  6 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
> index d1e0563..16ffb11 100644
> --- a/drivers/net/e1000e/82571.c
> +++ b/drivers/net/e1000e/82571.c
> @@ -212,6 +212,7 @@ static s32 e1000_init_mac_params_82571(struct e1000_adapter *adapter)
>  {
>  	struct e1000_hw *hw = &adapter->hw;
>  	struct e1000_mac_info *mac = &hw->mac;
> +	/* cannot be const */
>  	struct e1000_mac_operations *func = &mac->ops;
>  	u32 swsm = 0;
>  	u32 swsm2 = 0;
> @@ -1656,7 +1657,7 @@ static void e1000_clear_hw_cntrs_82571(struct e1000_hw *hw)
>  	temp = er32(ICRXDMTC);
>  }
>  
> -static struct e1000_mac_operations e82571_mac_ops = {
> +static const struct e1000_mac_operations e82571_mac_ops = {
>  	/* .check_mng_mode: mac type dependent */
>  	/* .check_for_link: media type dependent */
>  	.id_led_init		= e1000e_id_led_init,
> diff --git a/drivers/net/e1000e/e1000.h b/drivers/net/e1000e/e1000.h
> index 3e187b0..933f5da 100644
> --- a/drivers/net/e1000e/e1000.h
> +++ b/drivers/net/e1000e/e1000.h
> @@ -375,7 +375,7 @@ struct e1000_info {
>  	u32			pba;
>  	u32			max_hw_frame_size;
>  	s32			(*get_variants)(struct e1000_adapter *);
> -	struct e1000_mac_operations *mac_ops;
> +	const struct e1000_mac_operations *mac_ops;
>  	struct e1000_phy_operations *phy_ops;
>  	struct e1000_nvm_operations *nvm_ops;
>  };
> diff --git a/drivers/net/e1000e/es2lan.c b/drivers/net/e1000e/es2lan.c
> index ae5d736..06d47e0 100644
> --- a/drivers/net/e1000e/es2lan.c
> +++ b/drivers/net/e1000e/es2lan.c
> @@ -207,6 +207,7 @@ static s32 e1000_init_mac_params_80003es2lan(struct e1000_adapter *adapter)
>  {
>  	struct e1000_hw *hw = &adapter->hw;
>  	struct e1000_mac_info *mac = &hw->mac;
> +	/* cannot be const */
>  	struct e1000_mac_operations *func = &mac->ops;
>  
>  	/* Set media type */
> @@ -1365,7 +1366,7 @@ static void e1000_clear_hw_cntrs_80003es2lan(struct e1000_hw *hw)
>  	temp = er32(ICRXDMTC);
>  }
>  
> -static struct e1000_mac_operations es2_mac_ops = {
> +static const struct e1000_mac_operations es2_mac_ops = {
>  	.id_led_init		= e1000e_id_led_init,
>  	.check_mng_mode		= e1000e_check_mng_mode_generic,
>  	/* check_for_link dependent on media type */
> diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
> index eff3f47..3e0065b 100644
> --- a/drivers/net/e1000e/ich8lan.c
> +++ b/drivers/net/e1000e/ich8lan.c
> @@ -3451,7 +3451,7 @@ static void e1000_clear_hw_cntrs_ich8lan(struct e1000_hw *hw)
>  	}
>  }
>  
> -static struct e1000_mac_operations ich8_mac_ops = {
> +static const struct e1000_mac_operations ich8_mac_ops = {
>  	.id_led_init		= e1000e_id_led_init,
>  	.check_mng_mode		= e1000_check_mng_mode_ich8lan,
>  	.check_for_link		= e1000_check_for_copper_link_ich8lan,
> diff --git a/drivers/net/igb/e1000_82575.c b/drivers/net/igb/e1000_82575.c
> index f8f5772..3d5794f 100644
> --- a/drivers/net/igb/e1000_82575.c
> +++ b/drivers/net/igb/e1000_82575.c
> @@ -1400,7 +1400,7 @@ void igb_vmdq_set_replication_pf(struct e1000_hw *hw, bool enable)
>  	wr32(E1000_VT_CTL, vt_ctl);
>  }
>  
> -static struct e1000_mac_operations e1000_mac_ops_82575 = {
> +static const struct e1000_mac_operations e1000_mac_ops_82575 = {
>  	.reset_hw             = igb_reset_hw_82575,
>  	.init_hw              = igb_init_hw_82575,
>  	.check_for_link       = igb_check_for_link_82575,
> diff --git a/drivers/net/igb/e1000_hw.h b/drivers/net/igb/e1000_hw.h
> index 119869b..d58b7e5 100644
> --- a/drivers/net/igb/e1000_hw.h
> +++ b/drivers/net/igb/e1000_hw.h
> @@ -310,7 +310,7 @@ struct e1000_nvm_operations {
>  
>  struct e1000_info {
>  	s32 (*get_invariants)(struct e1000_hw *);
> -	struct e1000_mac_operations *mac_ops;
> +	const struct e1000_mac_operations *mac_ops;
>  	struct e1000_phy_operations *phy_ops;
>  	struct e1000_nvm_operations *nvm_ops;
>  };
> 
> 
