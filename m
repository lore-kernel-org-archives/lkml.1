Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab0BPUea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 15:34:30 -0500
Received: from kroah.org ([198.145.64.141]:55253 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757Ab0BPUe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 15:34:28 -0500
Date: Tue, 16 Feb 2010 12:34:22 -0800
From: Greg KH <greg@kroah.com>
To: NISHIMOTO Hiroki <tlayboy@gmail.com>
Cc: linux-kernel@vger.kernel.org, ben-linux@fluff.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] driver/misc: Add new driver for Avago ADJD-S371-QR999
Message-ID: <20100216203422.GA14839@kroah.com>
References: <1266156496-15269-1-git-send-email-tlayboy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266156496-15269-1-git-send-email-tlayboy@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 11:08:16PM +0900, NISHIMOTO Hiroki wrote:
> + * The main function of the ADJD-S371-QR999 is to detect color of object.
> + * If you need other functions led, reset, sleep, external clock,
> + * implement it youself by using gpio.
> + *
> + * ++ USAGE EXAMPLE ++
> + * + optimize the color value
> + *	# echo 3 > /sys/devices/platform/s371_qr999/capacitor/xxx_cap
> + *	# echo 1500 > /sys/devices/platform/s371_qr999/integration/xxx_int
> + *
> + * + get color values
> + *	# cat /sys/devices/platform/s371_qr999/raw_color
> + *
> + * + get color values except the influence of natural light
> + * 	# cat /sys/devices/platform/s371_qr999/trim_get
> + *	# cat /sys/devices/platform/s371_qr999/trim_color

As you are adding new sysfs files, you have to add the proper entries in
the Documentation/ABI/ directory as well.

Also, sysfs is ONE VALUE PER FILE, please do not do what you are doing
here with multiple values per a single file, that is not acceptable.

> + * Data Sheet
> + *	http://www.avagotech.com/docs/AV02-0314EN
> + * Application Note:
> + *	http://www.avagotech.com/docs/AV02-0359EN

I would recommend working with the hwmon developers to develop a
standard API for these types of devices, and use it instead of creating
your own.

thanks,

greg k-h
