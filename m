Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZGFPJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZGFPJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZGFPJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:09:42 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:44810 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbZGFPJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=jc/mu2ekhUZTABhT+U2jAS8KnCHU00gVmIj/78qy1hiI1MSaUavLkDu1gHyN63sIXf
         8UlDESXrJASvjGyRJuQxOTsv0o8Z2fys9n5gEkn8MgJXc2CUMSzNAuM2VY56QsHyRfuE
         WWEvzEUKYVZfQuJMKDEyXtpwXsDlO+5hi22vE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [PATCH] Staging: vt6656: remove dependency on WIRELESS_EXT version
Date: Mon, 6 Jul 2009 17:15:43 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc2-next-20090706-03300-ga0c36f0; KDE/4.2.4; i686; ; )
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, forest@alittletooquiet.net
References: <1246615634-14939-1-git-send-email-a.beregalov@gmail.com> <200907031539.20778.bzolnier@gmail.com> <20090704190932.GA17284@orion>
In-Reply-To: <20090704190932.GA17284@orion>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907061715.44264.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 July 2009 21:09:32 Alexander Beregalov wrote:
> > * It seems that both vt665x drivers should just select WIRELESS_EXT in
> >   their Kconfig's and then we can remove all remaining CONFIG_WIRELESS_EXT
> >   ifdefs.
> > 
> > * vt6656 probably also needs to depend on USB.
> > 
> > Alexander, could you look into it?
> 
> Like this?
> 
> 
> From 5dee9243562e2997a883ef994b0ebce3af6d0201 Mon Sep 17 00:00:00 2001
> From: Alexander Beregalov <a.beregalov@gmail.com>
> Date: Sat, 4 Jul 2009 23:03:18 +0400
> Subject: [PATCH] Staging: vt665x: depend on WIRELESS_EXT
> 
> Make vt665x depended on WIRELESS_EXT and remove remain ifdef's

[ some minor typos: depended -> dependent, remain -> remaining ]

> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Thanks, looks good (though "select WIRELESS_EXT" would be nicer IMHO).

I see that you've also added missing USB dependency while at it :)
(it would be would worth to mention it in the patch description).

> ---
>  drivers/staging/vt6655/Kconfig       |    2 +-
>  drivers/staging/vt6655/device.h      |    2 --
>  drivers/staging/vt6655/device_main.c |    8 --------
>  drivers/staging/vt6655/iwctl.c       |   10 ----------
>  drivers/staging/vt6655/iwctl.h       |    4 ----
>  drivers/staging/vt6656/Kconfig       |    1 +
>  drivers/staging/vt6656/main_usb.c    |    2 --
>  7 files changed, 2 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/staging/vt6655/Kconfig b/drivers/staging/vt6655/Kconfig
> index a01b1e4..9bec95a 100644
> --- a/drivers/staging/vt6655/Kconfig
> +++ b/drivers/staging/vt6655/Kconfig
> @@ -1,6 +1,6 @@
>  config VT6655
>     tristate "VIA Technologies VT6655 support"
> -   depends on PCI
> +   depends on WIRELESS_EXT && PCI
>     ---help---
>     This is a vendor-written driver for VIA VT6655.
>  
> diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
> index 6726b2c..287b141 100644
> --- a/drivers/staging/vt6655/device.h
> +++ b/drivers/staging/vt6655/device.h
> @@ -950,9 +950,7 @@ typedef struct __device_info {
>      UINT                    uChannel;
>      BOOL                    bMACSuspend;
>  
> -#ifdef WIRELESS_EXT
>  	struct iw_statistics	wstats;		// wireless stats
> -#endif /* WIRELESS_EXT */
>      BOOL                    bCommit;
>  
>  } DEVICE_INFO, *PSDevice;
> diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
> index 8846026..8800286 100644
> --- a/drivers/staging/vt6655/device_main.c
> +++ b/drivers/staging/vt6655/device_main.c
> @@ -1146,9 +1146,7 @@ device_found1(struct pci_dev *pcid, const struct pci_device_id *ent)
>      dev->irq                = pcid->irq;
>      dev->netdev_ops         = &device_netdev_ops;
>  
> -#ifdef CONFIG_WIRELESS_EXT
>  	dev->wireless_handlers = (struct iw_handler_def *)&iwctl_handler_def;
> -#endif
>  
>      rc = register_netdev(dev);
>      if (rc)
> @@ -3396,10 +3394,8 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
>  	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
>  #endif
>  
> -#ifdef WIRELESS_EXT
>  	struct iwreq *wrq = (struct iwreq *) rq;
>  	int                 rc =0;
> -#endif
>      PSMgmtObject        pMgmt = pDevice->pMgmt;
>      PSCmdRequest        pReq;
>  
> @@ -3411,8 +3407,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
>  
>      switch(cmd) {
>  
> -#ifdef WIRELESS_EXT
> -
>  	case SIOCGIWNAME:
>  		rc = iwctl_giwname(dev, NULL, (char *)&(wrq->u.name), NULL);
>  		break;
> @@ -3751,8 +3745,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
>  #endif // #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
>  //End Add -- //2008-0409-07, <Add> by Einsn Liu
>  
> -#endif // WIRELESS_EXT
> -
>      case IOCTL_CMD_TEST:
>  
>  		if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
> diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
> index b7c75a6..2ff8f24 100644
> --- a/drivers/staging/vt6655/iwctl.c
> +++ b/drivers/staging/vt6655/iwctl.c
> @@ -80,8 +80,6 @@ extern WORD TxRate_iwconfig;//2008-5-8 <add> by chester
>  #define SUPPORTED_WIRELESS_EXT                  17
>  #endif
>  
> -#ifdef WIRELESS_EXT
> -
>  static const long frequency_list[] = {
>      2412, 2417, 2422, 2427, 2432, 2437, 2442, 2447, 2452, 2457, 2462, 2467, 2472, 2484,
>      4915, 4920, 4925, 4935, 4940, 4945, 4960, 4980,
> @@ -90,8 +88,6 @@ static const long frequency_list[] = {
>      5700, 5745, 5765, 5785, 5805, 5825
>  	};
>  
> -#endif
> -
>  
>  /*---------------------  Static Classes  ----------------------------*/
>  
> @@ -105,8 +101,6 @@ static int          msglevel                =MSG_LEVEL_INFO;
>  
>  /*---------------------  Export Variables  --------------------------*/
>  
> -#ifdef WIRELESS_EXT
> -
>  struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
>  {
>  	PSDevice pDevice = netdev_priv(dev);
> @@ -2314,7 +2308,3 @@ const struct iw_handler_def	iwctl_handler_def =
>  	.private	= NULL,
>  	.private_args	= NULL,
>  };
> -
> -
> -
> -#endif // WIRELESS_EXT
> diff --git a/drivers/staging/vt6655/iwctl.h b/drivers/staging/vt6655/iwctl.h
> index 147af9d..44ee46c 100644
> --- a/drivers/staging/vt6655/iwctl.h
> +++ b/drivers/staging/vt6655/iwctl.h
> @@ -50,8 +50,6 @@ extern "C" {                            /* Assume C declarations for C++ */
>  #endif /* __cplusplus */
>  
>  
> -#ifdef WIRELESS_EXT
> -
>  struct iw_statistics *iwctl_get_wireless_stats (struct net_device *dev);
>  
>  
> @@ -231,8 +229,6 @@ int iwctl_siwmlme(struct net_device *dev,
>  #endif // #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
>  
>  
> -#endif
> -
>  extern const struct iw_handler_def	iwctl_handler_def;
>  extern const struct iw_priv_args	iwctl_private_args;
>  
> diff --git a/drivers/staging/vt6656/Kconfig b/drivers/staging/vt6656/Kconfig
> index f823a74..3165f2c 100644
> --- a/drivers/staging/vt6656/Kconfig
> +++ b/drivers/staging/vt6656/Kconfig
> @@ -1,5 +1,6 @@
>  config VT6656
>  	tristate "VIA Technologies VT6656 support"
> +	depends on WIRELESS_EXT && USB
>  	---help---
>  	This is a vendor-written driver for VIA VT6656.
>  
> diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
> index a3600c8..8a6814d 100644
> --- a/drivers/staging/vt6656/main_usb.c
> +++ b/drivers/staging/vt6656/main_usb.c
> @@ -856,9 +856,7 @@ vntwusb_found1(struct usb_interface *intf, const struct usb_device_id *id)
>  
>      netdev->netdev_ops         = &device_netdev_ops;
>  
> -#ifdef CONFIG_WIRELESS_EXT
>  	netdev->wireless_handlers = (struct iw_handler_def *)&iwctl_handler_def;
> -#endif /* WIRELESS_EXT */
>  
>     //2008-0623-01<Remark>by MikeLiu
>    //2007-0821-01<Add>by MikeLiu
