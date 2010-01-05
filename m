Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206Ab0AEFS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab0AEFS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 00:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203Ab0AEFS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 00:18:27 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:9248 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0AEFS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 00:18:26 -0500
Message-ID: <4B42C98B.8070300@chelsio.com>
Date: Tue, 05 Jan 2010 10:39:31 +0530
From: Rakesh Ranjan <rakesh@chelsio.com>
Organization: Chelsio Communications
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       Rakesh Ranjan <rakesh@chelsio.com>
Subject: Re: linux-next: manual merge of the net-current tree with the scsi-rc-fixes
 tree
References: <20100105085613.0a04d952.sfr@canb.auug.org.au> <20100104.143705.179916049.davem@davemloft.net>
In-Reply-To: <20100104.143705.179916049.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jan 2010 05:12:12.0828 (UTC) FILETIME=[A3B7B5C0:01CA8DC5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 04:07 AM, David Miller wrote:
> From: Stephen Rothwell<sfr@canb.auug.org.au>
> Date: Tue, 5 Jan 2010 08:56:13 +1100
>
>> Today's linux-next merge of the net-current tree got a conflict in
>> drivers/scsi/cxgb3i/cxgb3i_offload.c between commit
>> 44214ab474671e1ab5a860954db413bce52f7e04 ("[SCSI] cxgb3i: Fix a login
>> over vlan issue") from the scsi-rc-fixes tree and commit
>> 52ee264bca378835decb827d18b1d90b709ca4c9 ("cxgb3i: Fix a login over vlan
>> issue") from the net-current tree.
>>
>> These seem to be different version of the same change.  The version in
>> the net-current tree looks wrong - it contains
>>
>> if (dev->priv_flags&&  IFF_802_1Q_VLAN)
>>
>> but it presumably should be
>>
>> if (dev->priv_flags&  IFF_802_1Q_VLAN)
>>
>> as in the scsi-rc-fixes version.
>
> I checked the following into my tree so it should all work out.
>
> commit d3af9dd04f8795dc2761ecfa56632e4d0df0dae2
> Author: David S. Miller<davem@davemloft.net>
> Date:   Mon Jan 4 14:36:40 2010 -0800
>
>      cxgb3i: Fix flags test.
>
>      As noticed by Stephen Rothwell.
>
>      Signed-off-by: David S. Miller<davem@davemloft.net>
>
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
> index 4b8a513..7449d46 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
> +++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
> @@ -1442,7 +1442,7 @@ static int is_cxgb3_dev(struct net_device *dev)
>   	struct cxgb3i_sdev_data *cdata;
>   	struct net_device *ndev = dev;
>
> -	if (dev->priv_flags&&  IFF_802_1Q_VLAN)
> +	if (dev->priv_flags&  IFF_802_1Q_VLAN)
>   		ndev = vlan_dev_real_dev(dev);
>
>   	write_lock(&cdata_rwlock);

Hi David,

Sorry for the typo and thanks for fixing it.

Regards
Rakesh Ranjan

