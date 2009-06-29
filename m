Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbZF2TW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbZF2TW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZF2TWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:22:50 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:45417 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbZF2TWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:22:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAK+xSEpR9cBV/2dsb2JhbADOKQmEBAWBNw
Date: Mon, 29 Jun 2009 21:22:51 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] watchdog: w83697ug, fix lock imbalance
Message-ID: <20090629192251.GI3982@infomag.iguana.be>
References: <1246291239-3331-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246291239-3331-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Will add this to the linux-2.6-watchdog trees.

Kind regards,
Wim.

> Don't forget to unlock io_lock when w83697ug_select_wd_register fails in
> wdt_ctrl.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/watchdog/w83697ug_wdt.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
> index 883b5f7..a6c12de 100644
> --- a/drivers/watchdog/w83697ug_wdt.c
> +++ b/drivers/watchdog/w83697ug_wdt.c
> @@ -149,8 +149,10 @@ static void wdt_ctrl(int timeout)
>  {
>  	spin_lock(&io_lock);
>  
> -	if (w83697ug_select_wd_register() < 0)
> +	if (w83697ug_select_wd_register() < 0) {
> +		spin_unlock(&io_lock);
>  		return;
> +	}
>  
>  	outb_p(0xF4, WDT_EFER);    /* Select CRF4 */
>  	outb_p(timeout, WDT_EFDR); /* Write Timeout counter to CRF4 */
> -- 
> 1.6.3.2
> 
