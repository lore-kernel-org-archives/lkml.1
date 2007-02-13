Return-Path: <linux-kernel-owner+w=401wt.eu-S1751006AbXBMRXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006AbXBMRXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbXBMRXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:23:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbXBMRXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:23:24 -0500
Message-ID: <45D1F3B4.6020802@redhat.com>
Date: Tue, 13 Feb 2007 12:21:56 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       Jay Cliburn <jacliburn@bellsouth.net>, atl1-devel@lists.sourceforge.net
Subject: Re: [PATCH] fix atl1 braino
References: <20070213071256.GF4095@ftp.linux.org.uk>
In-Reply-To: <20070213071256.GF4095@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Spot the bug...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> 
> diff --git a/drivers/net/atl1/atl1_hw.c b/drivers/net/atl1/atl1_hw.c
> index 08b2d78..e28707a 100644
> --- a/drivers/net/atl1/atl1_hw.c
> +++ b/drivers/net/atl1/atl1_hw.c
> @@ -357,7 +357,7 @@ void atl1_hash_set(struct atl1_hw *hw, u32 hash_value)
>  	 */
>  	hash_reg = (hash_value >> 31) & 0x1;
>  	hash_bit = (hash_value >> 26) & 0x1F;
> -	mta = ioread32((hw + REG_RX_HASH_TABLE) + (hash_reg << 2));
> +	mta = ioread32((hw->hw_addr + REG_RX_HASH_TABLE) + (hash_reg << 2));
>  	mta |= (1 << hash_bit);
>  	iowrite32(mta, (hw->hw_addr + REG_RX_HASH_TABLE) + (hash_reg << 2));
>  }

ACK.

Thanks for catching this.
