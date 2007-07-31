Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbXGaXwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbXGaXwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbXGaXwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:52:42 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:32174 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbXGaXwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:52:42 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 19:52:41 EDT
Message-ID: <46AFC93F.6010104@chelsio.com>
Date: Tue, 31 Jul 2007 16:43:59 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/net/cxgb3/xgmac.c: remove dead code
References: <20070729145544.GA16817@stusta.de>
In-Reply-To: <20070729145544.GA16817@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jul 2007 23:42:47.0653 (UTC) FILETIME=[7FEF5950:01C7D3CC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>
> This patch removes dead code ("tx_xcnt" can never be != 0 at this place)
> spotted by the Coverity checker.
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>
Acked-by: Divy Le Ray <divy@chelsio.com>
>
>
> ---
>
>  drivers/net/cxgb3/xgmac.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> --- linux-2.6.22-rc6-mm1/drivers/net/cxgb3/xgmac.c.old  2007-07-24 
> 13:55:33.000000000 +0200
> +++ linux-2.6.22-rc6-mm1/drivers/net/cxgb3/xgmac.c      2007-07-24 
> 13:57:06.000000000 +0200
> @@ -510,38 +510,35 @@ int t3b2_mac_watchdog_task(struct cmac *
>         if (tx_mcnt == mac->tx_mcnt) {
>                 tx_xcnt = (G_TXSPI4SOPCNT(t3_read_reg(adap,
>                                                 
> A_XGM_TX_SPI4_SOP_EOP_CNT +
>                                                 mac->offset)));
>                 if (tx_xcnt == 0) {
>                         t3_write_reg(adap, A_TP_PIO_ADDR,
>                                      A_TP_TX_DROP_CNT_CH0 + macidx(mac));
>                         tx_tcnt = (G_TXDROPCNTCH0RCVD(t3_read_reg(adap,
>                                                       A_TP_PIO_DATA)));
>                 } else {
>                         goto rxcheck;
>                 }
>         } else {
>                 mac->toggle_cnt = 0;
>                 goto rxcheck;
>         }
>
> -       if (((tx_tcnt != mac->tx_tcnt) &&
> -            (tx_xcnt == 0) && (mac->tx_xcnt == 0)) ||
> -           ((mac->tx_mcnt == tx_mcnt) &&
> -            (tx_xcnt != 0) && (mac->tx_xcnt != 0))) {
> +       if ((tx_tcnt != mac->tx_tcnt) && (mac->tx_xcnt == 0))  {
>                 if (mac->toggle_cnt > 4) {
>                         status = 2;
>                         goto out;
>                 } else {
>                         status = 1;
>                         goto out;
>                 }
>         } else {
>                 mac->toggle_cnt = 0;
>                 goto rxcheck;
>         }
>
>  rxcheck:
>         if (rx_mcnt != mac->rx_mcnt)
>                 rx_xcnt = (G_TXSPI4SOPCNT(t3_read_reg(adap,
>                                                 
> A_XGM_RX_SPI4_SOP_EOP_CNT +
>                                                 mac->offset)));
>

