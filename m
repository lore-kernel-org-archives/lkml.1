Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYAETcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYAETcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 14:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbYAETcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 14:32:13 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:23442 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbYAETcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 14:32:12 -0500
Date: Sat, 5 Jan 2008 11:30:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage
 support
Message-Id: <20080105113024.209485f5.randy.dunlap@oracle.com>
In-Reply-To: <200801051546.SAA08947@raad.intranet>
References: <200801051546.SAA08947@raad.intranet>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008 18:41:39 +0300 Al Boldi wrote:

> 
> Select SCSI for USB Mass Storage support.
> 
> 
> Cc: David Brownell <david-b@pacbell.net>
> Cc: Greg KH <greg@kroah.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Al Boldi <a1426z@gawab.com>
> 
> ---
> 
> --- 23.a/drivers/usb/storage/Kconfig
> +++ 23.b/drivers/usb/storage/Kconfig
> @@ -2,14 +2,10 @@
>  # USB Storage driver configuration
>  #
>  
> -comment "NOTE: USB_STORAGE needs SCSI, and 'SCSI disk support' may"
> -	depends on USB
> -comment "also be needed; see USB_STORAGE Help for more information"
> -	depends on USB
> -
>  menuconfig USB_STORAGE
>  	tristate "USB Mass Storage support"
> -	depends on USB && SCSI
> +	depends on USB
> +	select SCSI

We try not to use 'select' on subsystems and try to limit its use
to library-like code that is relatively small.  Selecting SCSI
breaks both of those efforts.
Furthermore, we try to give the user help here in both the
comments and help text.

NAK as far as I am concerned.

>  	---help---
>  	  Say Y here if you want to connect USB mass storage devices to your
>  	  computer's USB port. This is the driver you need for USB
> @@ -18,13 +14,17 @@ menuconfig USB_STORAGE
>  	  similar devices. This driver may also be used for some cameras
>  	  and card readers.
>  
> -	  This option depends on 'SCSI' support being enabled, but you
> -	  probably also need 'SCSI device support: SCSI disk support'
> +	  This option selects 'SCSI' support , but you probably
> +	  also need 'SCSI device support: SCSI disk support'
>  	  (BLK_DEV_SD) for most USB storage devices.
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called usb-storage.
>  
> +if USB_STORAGE
> +comment "NOTE: USB_STORAGE selects SCSI, but 'SCSI disk support' may"
> +comment "also be needed; see USB_STORAGE Help for more information"
> +
>  config USB_STORAGE_DEBUG
>  	bool "USB Mass Storage verbose debug"
>  	depends on USB_STORAGE
> @@ -147,6 +147,8 @@ config USB_STORAGE_KARMA
>  	  on the resulting scsi device node returns the Karma to normal
>  	  operation.
>  
> +endif # USB_STORAGE
> +
>  config USB_LIBUSUAL
>  	bool "The shared table of common (or usual) storage devices"
>  	depends on USB



---
~Randy
desserts:  http://www.xenotime.net/linux/recipes/
