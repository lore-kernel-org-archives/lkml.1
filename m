Return-Path: <linux-kernel-owner+w=401wt.eu-S1765062AbYCFSJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765062AbYCFSJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935450AbYCFSIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:08:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:15640 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935439AbYCFSIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:08:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,457,1199692800"; 
   d="scan'208";a="304152092"
Message-ID: <47D032FA.9000909@intel.com>
Date: Thu, 06 Mar 2008 10:07:54 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Julia Lawall <julia@diku.dk>, e1000-devel@lists.sourceforge.net,
       xfs-masters <xfs-masters@oss.sgi.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [E1000-devel] [PATCH] drivers/net: convert & to &&
References: <Pine.LNX.4.58.0803061841000.1669@pc-041.diku.dk> <1204826347.5541.20.camel@localhost>
In-Reply-To: <1204826347.5541.20.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Mar 2008 18:07:55.0638 (UTC) FILETIME=[00A06960:01C87FB5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Thu, 2008-03-06 at 18:41 +0100, Julia Lawall wrote:
>> diff -u -p a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
>> --- a/drivers/net/e1000/e1000_main.c	2008-02-20 22:09:26.000000000 +0100
>> +++ b/drivers/net/e1000/e1000_main.c	2008-03-06 17:30:20.000000000 +0100
>> @@ -3872,10 +3872,12 @@ e1000_intr_msi(int irq, void *data)
>>  	adapter->total_tx_packets = 0;
>>  	adapter->total_rx_packets = 0;
>>
>> -	for (i = 0; i < E1000_MAX_INTR; i++)
>> -		if (unlikely(!adapter->clean_rx(adapter, adapter->rx_ring) &
>> -		   !e1000_clean_tx_irq(adapter, adapter->tx_ring)))
>> +	for (i = 0; i < E1000_MAX_INTR; i++) {
>> +		boolean_t c1 = adapter->clean_rx(adapter, adapter->rx_ring);
>> +		boolean_t c2 = e1000_clean_tx_irq(adapter, adapter->tx_ring);
>> +		if (unlikely(!c1 && !c2))
>>  			break;
>> +	}
> 
> Perhaps also a s/boolean_t/bool/g kernel wide?

send me a patch for e1000 and for ixgb and I'll happily apply those :)

(which, BTW also could use the uint32_t -> u32 (etc) changes... while you're at it)

Auke


> 
> $ grep -wrl boolean_t *
> 
> drivers/net/e1000/e1000.h
> drivers/net/e1000/e1000_ethtool.c
> drivers/net/e1000/e1000_hw.c
> drivers/net/e1000/e1000_hw.h
> drivers/net/e1000/e1000_main.c
> drivers/net/e1000/e1000_osdep.h
> drivers/net/ixgb/ixgb.h
> drivers/net/ixgb/ixgb_ee.c
> drivers/net/ixgb/ixgb_ee.h
> drivers/net/ixgb/ixgb_ethtool.c
> drivers/net/ixgb/ixgb_hw.c
> drivers/net/ixgb/ixgb_hw.h
> drivers/net/ixgb/ixgb_main.c
> drivers/net/ixgb/ixgb_osdep.h
> fs/xfs/quota/xfs_dquot.c
> fs/xfs/quota/xfs_qm.c
> fs/xfs/quota/xfs_qm.h
> fs/xfs/quota/xfs_qm_syscalls.c
> fs/xfs/quota/xfs_trans_dquot.c
> fs/xfs/xfs_ialloc.c
> fs/xfs/xfs_ialloc.h
> fs/xfs/xfs_inode.c
> fs/xfs/xfs_inode.h
> fs/xfs/xfs_log.c
> fs/xfs/xfs_vfsops.c
> fs/xfs/xfs_utils.c
> fs/xfs/xfs_types.h
> fs/xfs/xfs_vnodeops.c
> 
> 
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> E1000-devel mailing list
> E1000-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/e1000-devel

