Return-Path: <linux-kernel-owner+w=401wt.eu-S1756284AbYAZJ4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbYAZJ4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 04:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYAZJ4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 04:56:06 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:37580 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbYAZJ4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 04:56:04 -0500
Message-ID: <479B03AE.3090600@garzik.org>
Date: Sat, 26 Jan 2008 04:55:58 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] Shut up warnings from files under drivers/
References: <20080126093007.GB20935@hacking>
In-Reply-To: <20080126093007.GB20935@hacking>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
> diff --git a/drivers/video/kyro/fbdev.c b/drivers/video/kyro/fbdev.c
> index acb9370..437ebd0 100644
> --- a/drivers/video/kyro/fbdev.c
> +++ b/drivers/video/kyro/fbdev.c
> @@ -90,7 +90,9 @@ static int nomtrr __devinitdata = 0;
>  
>  /* PCI driver prototypes */
>  static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
> +#if defined(MODULE) || defined(CONFIG_HOTPLUG)
>  static void kyrofb_remove(struct pci_dev *pdev);
> +#endif
>  
>  static struct fb_videomode kyro_modedb[] __devinitdata = {
>  	{
> @@ -754,6 +756,7 @@ out_unmap:
>  	return -EINVAL;
>  }
>  
> +#if defined(MODULE) || defined(CONFIG_HOTPLUG)
>  static void __devexit kyrofb_remove(struct pci_dev *pdev)
>  {
>  	struct fb_info *info = pci_get_drvdata(pdev);
> @@ -783,6 +786,7 @@ static void __devexit kyrofb_remove(struct pci_dev *pdev)
>  	pci_set_drvdata(pdev, NULL);
>  	framebuffer_release(info);
>  }
> +#endif


Quite strange -- due to __devexit_p() and the __devexit marker, ifdefs 
should not be needed.

I would look into why that isn't working as designed in these cases...

	Jeff


