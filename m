Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYCYQmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYCYQmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbYCYQmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:42:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:29806 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757733AbYCYQmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:42:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,553,1199692800"; 
   d="scan'208";a="360343053"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][RESEND] wireless: convert !X & Y to !(X & Y) in iwl4965_is_fat_tx_allowed()
Date: Tue, 25 Mar 2008 09:30:58 -0700
Message-ID: <D936D925018D154694D8A362EEB08920040370C5@orsmsx416.amr.corp.intel.com>
In-Reply-To: <47E9226C.7090403@tiscali.nl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][RESEND] wireless: convert !X & Y to !(X & Y) in iwl4965_is_fat_tx_allowed()
thread-index: AciOksrFvjQWJt3wRFClULTGyHXoZgAApEhA
References: <47E9226C.7090403@tiscali.nl>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Roel Kluin" <12o3l@tiscali.nl>, "Zhu, Yi" <yi.zhu@intel.com>
Cc: <linux-wireless@vger.kernel.org>, "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Mar 2008 16:30:59.0020 (UTC) FILETIME=[9B8030C0:01C88E95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 25, 2008 9:04 AM, Roel Kluin  wrote:

> from include/linux/ieee80211.h:274:
> #define IEEE80211_HT_CAP_SUP_WIDTH              0x0002 ---
> ! has a higher priority than &
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c
> b/drivers/net/wireless/iwlwifi/iwl-4965.c
> index d727de8..6576757 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -4589,7 +4589,7 @@ static u8
> iwl4965_is_fat_tx_allowed(struct iwl4965_priv *priv,
> 
> 	if (sta_ht_inf) {
> 		if ((!sta_ht_inf->ht_supported) ||
> -		   (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
> +		   (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
return 0;
> 	}

This patch has already been acked and merged into wireless-testing, and
afaik already pushed further upstream.

Reinette
