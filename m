Return-Path: <linux-kernel-owner+w=401wt.eu-S1762186AbYAVJ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762186AbYAVJ6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761514AbYAVJ4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:56:16 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58668 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761498AbYAVJ4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:56:14 -0500
Message-ID: <4795BDBB.10904@garzik.org>
Date: Tue, 22 Jan 2008 04:56:11 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: jacliburn@bellsouth.net
CC: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net
Subject: Re: [PATCH 06/26] atl1: update initialization parameters
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net> <1199152804-3889-7-git-send-email-jacliburn@bellsouth.net>
In-Reply-To: <1199152804-3889-7-git-send-email-jacliburn@bellsouth.net>
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
> Update initialization parameters to match the current vendor driver
> version 1.2.40.2.
> 
> Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
> ---
>  drivers/net/atlx/atl1.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
> index 262d3ca..695dcbc 100644
> --- a/drivers/net/atlx/atl1.c
> +++ b/drivers/net/atlx/atl1.c
> @@ -136,20 +136,20 @@ static int __devinit atl1_sw_init(struct atl1_adapter *adapter)
>  	hw->rfd_fetch_gap = 1;
>  	hw->rx_jumbo_th = adapter->rx_buffer_len / 8;
>  	hw->rx_jumbo_lkah = 1;
> -	hw->rrd_ret_timer = 16;
> -	hw->tpd_burst = 4;
> +	hw->rrd_ret_timer = 4;	/* 8 us */
> +	hw->tpd_burst = 8;
>  	hw->tpd_fetch_th = 16;
> -	hw->txf_burst = 0x100;
> +	hw->txf_burst = 0x200;
>  	hw->tx_jumbo_task_th = (hw->max_frame_size + 7) >> 3;
>  	hw->tpd_fetch_gap = 1;
>  	hw->rcb_value = atl1_rcb_64;
>  	hw->dma_ord = atl1_dma_ord_enh;
> -	hw->dmar_block = atl1_dma_req_256;
> -	hw->dmaw_block = atl1_dma_req_256;
> +	hw->dmar_block = atl1_dma_req_1024;
> +	hw->dmaw_block = atl1_dma_req_1024;
>  	hw->cmb_rrd = 4;
>  	hw->cmb_tpd = 4;
> -	hw->cmb_rx_timer = 1;	/* about 2us */
> -	hw->cmb_tx_timer = 1;	/* about 2us */
> +	hw->cmb_rx_timer = 2;	/* about 4us */
> +	hw->cmb_tx_timer = 256;	/* about 512us */
>  	hw->smb_timer = 100000;	/* about 200ms */

ACK without any better knowledge...  but is any addition insight 
available at all?

