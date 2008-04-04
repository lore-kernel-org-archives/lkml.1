Return-Path: <linux-kernel-owner+w=401wt.eu-S1752777AbYDDEer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbYDDEer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 00:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYDDEej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 00:34:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:33100 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbYDDEei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 00:34:38 -0400
Date: Thu, 3 Apr 2008 21:34:34 -0700
From: Andrew Morton <akpm@kernel.org>
To: Gerd Luyten <gluyten@skynet.be>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usbcore, kernel 2.6.18.1
Message-Id: <20080403213434.05362b67.akpm@kernel.org>
In-Reply-To: <1207228494.8542.9.camel@workstation.dyn.nu>
References: <1207228494.8542.9.camel@workstation.dyn.nu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Apr 2008 15:14:54 +0200 Gerd Luyten <gluyten@skynet.be> wrote:

> This patch is to eventually detect a Velleman K8055 USB device.
> Without the patch it will fail detection with following errors:
> usb 1-2: can't read configurations, error -110
> => probably because of usb non-conformance reason of the K8055 card.
> (timing issues...)
> 
> With this patch, detection will keep on trying until usb card gets
> recognized.
> This patch adds a device reset in the "fail:" sequence instead of just
> marking the device state as NOTATTACHED.
> 
> [gluyten@workstation pup214]$ diff -u
> linux-2.6.18.1/drivers/usb/core/hub.c hub.c
> --- linux-2.6.18.1/drivers/usb/core/hub.c       2006-10-14
> 05:34:03.000000000 +0200
> +++ hub.c       2008-04-03 14:47:49.000000000 +0200
> @@ -1450,7 +1450,9 @@
>         return 0;
> 
>  fail:
> -       usb_set_device_state(udev, USB_STATE_NOTATTACHED);
> +//     usb_set_device_state(udev, USB_STATE_NOTATTACHED);
> +       usb_lock_device_for_reset(udev, NULL);
> +       usb_reset_composite_device(udev, NULL);
>         return err;
>  }
> 

2.6.18 is very old.  Does 2.6.24 (or later) also need fixing?

Thanks.
