Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZCFR6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZCFR6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZCFR54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:57:56 -0500
Received: from kroah.org ([198.145.64.141]:34421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752024AbZCFR54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:57:56 -0500
Date: Fri, 6 Mar 2009 09:49:13 -0800
From: Greg KH <greg@kroah.com>
To: Martin Bammer <mrbm74@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: usb-storage: Wait less time for settling when a memory device
	is connected
Message-ID: <20090306174913.GB3099@kroah.com>
References: <1236335647.16732.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236335647.16732.12.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 11:34:07AM +0100, Martin Bammer wrote:
> Hi,

First off, usb issues/patches should be sent to the
linux-usb@vger.kernel.org list so they don't get ignored.

> I was wondering why the usb-storage driver waits for my usb-stick and my
> sdhc-card 5s before scanning. IMHO this is only needed for HDs. I've
> created a patch for the driver which shortens the timeout to 1s when a
> memory device is detected.
> But I'm not shure if the detection code is right for all devices. This
> maybe has to be tested and discussed.
> I've tested it with a usb-stick, a sdhc-card and a usb-harddrive.
> This patch is created for kernel 2.6.27.18.
> 
> Please CC me for answers to this thread.
> 
> --- a/drivers/usb/storage/usb.c 2009-03-03 23:33:37.000000000 +0100
> +++ b/drivers/usb/storage/usb.c 2009-03-03 23:32:44.000000000 +0100
> @@ -913,10 +913,16 @@ static int usb_stor_scan_thread(void * _
>  
>         set_freezable();
>  
> +       /* Shorten delay time for memory sticks/cards */
> +       if ((1 == us->pusb_dev->descriptor.iManufacturer)
> +           && (2 == us->pusb_dev->descriptor.iProduct)
> +           && (3 == us->pusb_dev->descriptor.iSerialNumber)
> +           && (delay_use > 0)) delay_use = 1;

Please always run your patches through scripts/checkpatch.pl first.

Why are you testing for the manufacturer and product here?

And what's wrong with just changing the module parameter for delay_use,
that is what it is there for.  No kernel patch should be needed.

thanks,

greg k-h
