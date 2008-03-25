Return-Path: <linux-kernel-owner+w=401wt.eu-S1759652AbYCYSao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759652AbYCYSao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759136AbYCYSaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:30:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:6101 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758876AbYCYSaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:30:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,553,1199692800"; 
   d="scan'208";a="223049444"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH][RESEND] wireless: convert !X & Y to !(X & Y) iniwl4965_is_fat_tx_allowed()
Date: Tue, 25 Mar 2008 11:26:28 -0700
Message-ID: <D936D925018D154694D8A362EEB08920040372DB@orsmsx416.amr.corp.intel.com>
In-Reply-To: <20080325174227.GB3026@tuxdriver.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH][RESEND] wireless: convert !X & Y to !(X & Y) iniwl4965_is_fat_tx_allowed()
thread-index: AciOo7UzUG7c6LhlTTKVHSvxeGBKfgAAR9Cw
References: <47E9226C.7090403@tiscali.nl> <D936D925018D154694D8A362EEB08920040370C5@orsmsx416.amr.corp.intel.com> <20080325174227.GB3026@tuxdriver.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Roel Kluin" <12o3l@tiscali.nl>, "Zhu, Yi" <yi.zhu@intel.com>,
       <linux-wireless@vger.kernel.org>, "lkml" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 Mar 2008 18:26:29.0915 (UTC) FILETIME=[BEA2D6B0:01C88EA5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 25, 2008 10:42 AM, John W. Linville  wrote:

> On Tue, Mar 25, 2008 at 09:30:58AM -0700, Chatre, Reinette wrote:
>> On Tuesday, March 25, 2008 9:04 AM, Roel Kluin  wrote:
>> 
>>> from include/linux/ieee80211.h:274:
>>> #define IEEE80211_HT_CAP_SUP_WIDTH              0x0002 ---
>>> ! has a higher priority than &
>>> 
>>> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>>> ---
>>> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c
>>> b/drivers/net/wireless/iwlwifi/iwl-4965.c
>>> index d727de8..6576757 100644
>>> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
>>> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
>>> @@ -4589,7 +4589,7 @@ static u8
>>> iwl4965_is_fat_tx_allowed(struct iwl4965_priv *priv,
>>> 
>>> 	if (sta_ht_inf) {
>>> 		if ((!sta_ht_inf->ht_supported) ||
>>> -		   (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
>>> +		   (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
return 0;
>>> 	}
>> 
>> This patch has already been acked and merged into wireless-testing,
>> and afaik already pushed further upstream.
> 
> Yes, but FWIW the problem exists in the 2.6.25 stream as well.
> I've been holding-back a patch to fix it there, trying to decide if it
> is worth creating the merge conflict to fix it there.  I'm inclined
> to think it is better to let things lay as they are and send that
> patch for the -stable series once 2.6.25 ships.
> 
> Any thoughts on that?

I see. The patch is small and I thus assume a merge conflict will be
easy to resolve. Yet ... I do not know what is really involved in the
upstream code movements, while I know that you do. If you say it is
better to wait until stable then I am ok with it.

Thanks

Reinette
