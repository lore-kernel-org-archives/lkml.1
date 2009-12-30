Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZL3H67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZL3H67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 02:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZL3H67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 02:58:59 -0500
Received: from mail.vyatta.com ([76.74.103.46]:35900 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbZL3H66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 02:58:58 -0500
Date: Tue, 29 Dec 2009 23:58:35 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Berck E. Nash" <flyboy@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: sky2 panic in 2.6.32.1 under load (new oops)
Message-ID: <20091229235835.1f260eb0@nehalam>
In-Reply-To: <4B3AFFE8.3060409@majjas.com>
References: <4B300A2A.8040305@gmail.com>
	<4B300E30.9090707@majjas.com>
	<4B3114E3.1070602@majjas.com>
	<4B329FA3.9090904@majjas.com>
	<20091223230102.4bb0100e.akpm@linux-foundation.org>
	<4B34E847.8010809@majjas.com>
	<20091225152200.1cf11dfe@nehalam>
	<4B3581C7.8000702@majjas.com>
	<20091226095723.7ac82b18@nehalam>
	<4B367409.5060202@majjas.com>
	<4B379378.4000102@majjas.com>
	<20091227102238.0df149f9@nehalam>
	<4B37B7E2.5070307@majjas.com>
	<20091229093023.3ad24786@nehalam>
	<4B3A5048.9090700@majjas.com>
	<20091229114938.1f4d1c5c@nehalam>
	<4B3AFFE8.3060409@majjas.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Dec 2009 02:23:20 -0500
Michael Breuer <mbreuer@majjas.com> wrote:

> Ok - I called dump_txring from sky2_net_intr:
> --- a/drivers/net/sky2.c
> +++ b/drivers/net/sky2.c
> @@ -2725,8 +2791,10 @@ static void sky2_watchdog(unsigned long arg)
>   /* Hardware/software error handling */
>   static void sky2_err_intr(struct sky2_hw *hw, u32 status)
>   {
> -       if (net_ratelimit())
> +       if (net_ratelimit()) {
>                  dev_warn(&hw->pdev->dev, "error interrupt 
> status=%#x\n", status);
> +               dump_txring(hw, 0);
> +       }
> 
>          if (status & Y2_IS_HW_ERR)
>                  sky2_hw_intr(hw);
> 
> And got this:
> Dec 30 02:17:23 mail kernel: sky2 0000:06:00.0: error interrupt 
> status=0x40000008
> Dec 30 02:17:23 mail kernel: sky2 0000:06:00.0: error interrupt 
> status=0x40000008
> Dec 30 02:17:23 mail kernel: sky2 Tx ring pending=28...30 report=29 done=29
> Dec 30 02:17:23 mail kernel: sky2 Tx ring pending=28...30 report=29 done=29
> Dec 30 02:17:23 mail kernel: sky2 0000:06:00.0: error interrupt status=0x8
> Dec 30 02:17:23 mail kernel: sky2 0000:06:00.0: error interrupt status=0x8
> Dec 30 02:17:23 mail kernel: sky2 Tx ring pending=30...32 report=30 done=31
> Dec 30 02:17:23 mail kernel: sky2 Tx ring pending=30...32 report=30 done=31
> 

I notice that you have NOUVEAU Nvidia drivers loaded? The one difference in HW
between your board and mine is that I have ATI video card.

-- 
