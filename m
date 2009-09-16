Return-Path: <linux-kernel-owner+w=401wt.eu-S1759835AbZIPTy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759835AbZIPTy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 15:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759054AbZIPTyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 15:54:19 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41177 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbZIPTyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 15:54:15 -0400
Date: Wed, 16 Sep 2009 21:54:18 +0200
From: Andreas Mohr <andi@lisas.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Andreas Mohr <andi@lisas.de>, Oliver Neukum <oliver@neukum.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, laurent.pinchart@skynet.be,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: usb autosuspend is history after S2R (also on 2.6.31; UVC?)
Message-ID: <20090916195418.GB15489@rhlx01.hs-esslingen.de>
References: <20090915185145.GA31490@rhlx01.hs-esslingen.de> <200909152148.29662.oliver@neukum.org> <20090916181910.GA28260@rhlx01.hs-esslingen.de> <20090916195156.GA30867@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916195156.GA30867@electric-eye.fr.zoreil.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 16, 2009 at 09:51:56PM +0200, Francois Romieu wrote:
> Andreas Mohr <andi@lisas.de> :
> [...]
> > Anyway, doesn't change the fact that the r8169 WOL PHY setting is toast
> > after every S2R as well ;)
> 
> Stealth tester, he ?

Wait, you mean this is the patch to fix it that you created just now,
and it's that easy?
I'd have expected needing to fiddle with PHY power-management registers
and such stuff (while remembering pre-suspend status)
upon resume() handlers.

And sorry for not reporting it earlier (provoking that "Stealth tester"
above, right?), but I had kept tabs on it.

> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index 50c6a3c..e0af22f 100644
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c
> @@ -3962,8 +3962,7 @@ static int rtl8169_resume(struct device *device)
>  		goto out;
>  
>  	netif_device_attach(dev);
> -
> -	rtl8169_schedule_work(dev, rtl8169_reset_task);
> +	netif_wake_queue(dev);
>  out:
>  	return 0;
>  }

Crap, this is now the third thing waiting to get patched; looks like
I need to do another build for real now.

Thanks a lot,

Andreas Mohr
