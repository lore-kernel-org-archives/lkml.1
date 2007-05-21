Return-Path: <linux-kernel-owner+w=401wt.eu-S1759156AbXEUPK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156AbXEUPK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763687AbXEUPKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:10:06 -0400
Received: from nn7.de ([85.214.94.156]:44126 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763667AbXEUPKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:10:04 -0400
Subject: Re: [Bug 8498], [Bug 8510], and Re: Can't s2ram 22-rc2
From: Soeren Sonnenburg <kernel@nn7.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Avuton Olrich <avuton@gmail.com>,
       Greg KH <greg@kroah.com>, "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0705211040330.4496-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0705211040330.4496-100000@iolanthe.rowland.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 21 May 2007 17:10:00 +0200
Message-Id: <1179760200.4082.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 10:51 -0400, Alan Stern wrote:
> On Sat, 19 May 2007, Greg KH wrote:

> It turns out that the patch I originally wrote to fix this is in
> conflict with one of Raphael's patches (make freezeable workqueues
> singlethread) already added to 2.6.22-rc2.  So here's an updated
> version for that kernel.
> 
> Andrey, Soeren, and Avuton: Please try this patch with 2.6.22-rc2 or 
> later and see if it fixes your problems.
> 
> Greg, if this works then I'll send it in the proper form for a patch, 
> and you can use it to replace
> 
> 	usb-make-the-autosuspend-workqueue-thread-freezable.patch


works perfect, i.e. the machine survived 3 s2ram cycles and rebooted
cleanly :-))

apply! apply!

Soeren

> Alan Stern
> 
> 
> Index: 2.6.22-rc2/drivers/usb/core/usb.c
> ===================================================================
> --- 2.6.22-rc2.orig/drivers/usb/core/usb.c
> +++ 2.6.22-rc2/drivers/usb/core/usb.c
> @@ -205,7 +205,7 @@ struct device_type usb_device_type = {
>  
>  static int ksuspend_usb_init(void)
>  {
> -	ksuspend_usb_wq = create_singlethread_workqueue("ksuspend_usbd");
> +	ksuspend_usb_wq = create_freezeable_workqueue("ksuspend_usbd");
>  	if (!ksuspend_usb_wq)
>  		return -ENOMEM;
>  	return 0;
> 
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
