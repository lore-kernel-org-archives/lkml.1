Return-Path: <linux-kernel-owner+w=401wt.eu-S934916AbYCFSAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934916AbYCFSAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759519AbYCFSAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:00:16 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4683 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758419AbYCFSAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:00:14 -0500
Subject: Re: [PATCH] drivers/net: convert & to &&
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia@diku.dk>
Cc: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, xfs-masters <xfs-masters@oss.sgi.com>
In-Reply-To: <Pine.LNX.4.58.0803061841000.1669@pc-041.diku.dk>
References: <Pine.LNX.4.58.0803061841000.1669@pc-041.diku.dk>
Content-Type: text/plain
Date: Thu, 06 Mar 2008 09:59:07 -0800
Message-Id: <1204826347.5541.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.1mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-06 at 18:41 +0100, Julia Lawall wrote:
> diff -u -p a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
> --- a/drivers/net/e1000/e1000_main.c	2008-02-20 22:09:26.000000000 +0100
> +++ b/drivers/net/e1000/e1000_main.c	2008-03-06 17:30:20.000000000 +0100
> @@ -3872,10 +3872,12 @@ e1000_intr_msi(int irq, void *data)
>  	adapter->total_tx_packets = 0;
>  	adapter->total_rx_packets = 0;
> 
> -	for (i = 0; i < E1000_MAX_INTR; i++)
> -		if (unlikely(!adapter->clean_rx(adapter, adapter->rx_ring) &
> -		   !e1000_clean_tx_irq(adapter, adapter->tx_ring)))
> +	for (i = 0; i < E1000_MAX_INTR; i++) {
> +		boolean_t c1 = adapter->clean_rx(adapter, adapter->rx_ring);
> +		boolean_t c2 = e1000_clean_tx_irq(adapter, adapter->tx_ring);
> +		if (unlikely(!c1 && !c2))
>  			break;
> +	}

Perhaps also a s/boolean_t/bool/g kernel wide?

$ grep -wrl boolean_t *

drivers/net/e1000/e1000.h
drivers/net/e1000/e1000_ethtool.c
drivers/net/e1000/e1000_hw.c
drivers/net/e1000/e1000_hw.h
drivers/net/e1000/e1000_main.c
drivers/net/e1000/e1000_osdep.h
drivers/net/ixgb/ixgb.h
drivers/net/ixgb/ixgb_ee.c
drivers/net/ixgb/ixgb_ee.h
drivers/net/ixgb/ixgb_ethtool.c
drivers/net/ixgb/ixgb_hw.c
drivers/net/ixgb/ixgb_hw.h
drivers/net/ixgb/ixgb_main.c
drivers/net/ixgb/ixgb_osdep.h
fs/xfs/quota/xfs_dquot.c
fs/xfs/quota/xfs_qm.c
fs/xfs/quota/xfs_qm.h
fs/xfs/quota/xfs_qm_syscalls.c
fs/xfs/quota/xfs_trans_dquot.c
fs/xfs/xfs_ialloc.c
fs/xfs/xfs_ialloc.h
fs/xfs/xfs_inode.c
fs/xfs/xfs_inode.h
fs/xfs/xfs_log.c
fs/xfs/xfs_vfsops.c
fs/xfs/xfs_utils.c
fs/xfs/xfs_types.h
fs/xfs/xfs_vnodeops.c


