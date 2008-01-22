Return-Path: <linux-kernel-owner+w=401wt.eu-S1762503AbYAVJ5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762503AbYAVJ5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760926AbYAVJzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:55:36 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58658 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760674AbYAVJze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:55:34 -0500
Message-ID: <4795BD93.8070303@garzik.org>
Date: Tue, 22 Jan 2008 04:55:31 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: jacliburn@bellsouth.net
CC: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net
Subject: Re: [PATCH 05/26] atl1: print debug info if rrd error
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net> <1199152804-3889-6-git-send-email-jacliburn@bellsouth.net>
In-Reply-To: <1199152804-3889-6-git-send-email-jacliburn@bellsouth.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jacliburn@bellsouth.net wrote:
> From: Jay Cliburn <jacliburn@bellsouth.net>
> 
> Add some debug dev_printks if we encounter a bad receive return descriptor.
> 
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> ---
>  drivers/net/atlx/atl1.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
> index 239641f..262d3ca 100644
> --- a/drivers/net/atlx/atl1.c
> +++ b/drivers/net/atlx/atl1.c
> @@ -1127,7 +1127,26 @@ static void atl1_intr_rx(struct atl1_adapter *adapter)
>  		if (likely(rrd->xsz.valid)) {	/* packet valid */
>  chk_rrd:
>  			/* check rrd status */
> -			if (likely(rrd->num_buf == 1))
> +			if (rrd->num_buf != 1) {
> +				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
> +					"rx_buf_len = %d\n",
> +					adapter->rx_buffer_len);
> +				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
> +					"RRD num_buf = %d\n",
> +					rrd->num_buf);
> +				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
> +					"RRD pkt_len = %d\n",
> +					rrd->xsz.xsum_sz.pkt_size);
> +				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
> +					"RRD pkt_flg = 0x%08X\n",
> +					rrd->pkt_flg);
> +				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
> +					"RRD err_flg = 0x%08X\n",
> +					rrd->err_flg);
> +				dev_printk(KERN_DEBUG, &adapter->pdev->dev,
> +					"RRD vlan_tag = 0x%08X\n",
> +					rrd->vlan_tag);
> +			} else

look into netif_msg_*, which enables via ethtool very fine-grained 
selection of messages.

