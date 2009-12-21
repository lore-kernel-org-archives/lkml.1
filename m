Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbZLUQWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbZLUQWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbZLUQWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:22:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbZLUQV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:21:57 -0500
Date: Mon, 21 Dec 2009 08:20:48 -0800
From: Greg KH <gregkh@suse.de>
To: Alexander Strakh <strakh@ispras.ru>
Cc: Thomas Winischhofer <thomas@winischhofer.net>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: BUG null dereference in driver
	./drivers/usb/misc/sisusbvga/sisusb.c
Message-ID: <20091221162048.GB7091@suse.de>
References: <200912212003.10697.strakh@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912212003.10697.strakh@ispras.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 08:03:10PM +0000, Alexander Strakh wrote:
>         KERNEL_VERSION: 2.6.32
>         SUBJECT: null derefernce in function sisusb_probe
>         SUBSCRIBE:
>         In driver drivers/usb/misc/sisusbvga/sisusb.c in function 
> sisusb_probe:
> 
> 1. if in line 3085 after calling function kzalloc variable sisub = 
> NULL, then we goto line 3086.
> 2. In line 3086:  null dereference of sisusb - "&sisusb->sisusb_dev->dev".
> 
> 3084         /* Allocate memory for our private */
> 3085         if (!(sisusb = kzalloc(sizeof(*sisusb), GFP_KERNEL))) {
> 3086                 dev_err(&sisusb->sisusb_dev->dev, "Failed to allocate 
> memory for private data\n");
> 3087                 return -ENOMEM;
> 3088         }
> 3089         kref_init(&sisusb->kref);

Good catch, care to send a patch?

thanks,

greg k-h
