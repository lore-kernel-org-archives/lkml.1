Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZLOHC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZLOHC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZLOHC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:02:27 -0500
Received: from adelie.canonical.com ([91.189.90.139]:47541 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZLOHC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:02:26 -0500
Message-ID: <4B273479.6050502@canonical.com>
Date: Tue, 15 Dec 2009 15:02:17 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
       stable@kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: Re: [stable] [PATCH 2/2] iwlwifi: unify iwl_setup_rxon_timing
References: <1260848655-5582-1-git-send-email-ike.pan@canonical.com> <1260848710-5650-1-git-send-email-ike.pan@canonical.com> <20091215041500.GB31200@kroah.com>
In-Reply-To: <20091215041500.GB31200@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Dec 15, 2009 at 11:45:10AM +0800, Ike Panhc wrote:
>> This patch unifies setup_rxon_timing funcions
>> of AGN and 3945. HWs differ only in supported maximal
>> beacon interval. This is reflected in hw_paras.max_beacon_itrvl
>>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> (cherry picked from commit 2c2f3b33888419fb9e7d015b9dc67b9db4437efa)
>>
>> Conflicts:
>>
>> 	drivers/net/wireless/iwlwifi/iwl-dev.h
> 
> What does this mean?
> 
After cherry-pick:

--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@@ -625,7 -608,7 +625,11 @@@ struct iwl_hw_params 
	u8  max_stations;
	u8  bcast_sta_id;
	u8 fat_channel;
++<<<<<<< HEAD:drivers/net/wireless/iwlwifi/iwl-dev.h
 +	u8 sw_crypto;
++=======
+	u8  max_beacon_itrvl;   /* in 1024 ms */
++>>>>>>> 2c2f3b3... iwlwifi: unify iwl_setup_rxon_timing:drivers/net/wireless/iwlwifi/iwl-dev.h
	u32 max_inst_size;
	u32 max_data_size;
	u32 max_bsm_size;

The sw_crypto is removed in the prior commit (90e8e4), and the commit
is not in the stable tree. We still need sw_crypto.

So, the patch is modified to keep sw_crypto.

--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -626,6 +626,7 @@ struct iwl_hw_params {
	u8  bcast_sta_id;
	u8 fat_channel;
	u8 sw_crypto;
+	u8  max_beacon_itrvl;   /* in 1024 ms */
	u32 max_inst_size;
	u32 max_data_size;
	u32 max_bsm_size;

>> CC: stable@kernel.org
>> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
>>
>> BugLink: http://bugs.launchpad.net/bugs/496496
> 
> What are you expecting this patch to be applied to?
> 
> confused,
Please consider applying to linux-2.6.31.y

> 
> greg k-h
