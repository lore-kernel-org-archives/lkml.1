Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbXIJQdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbXIJQdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 12:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbXIJQdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 12:33:18 -0400
Received: from brick.kernel.dk ([87.55.233.238]:2150 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755569AbXIJQdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 12:33:18 -0400
Date: Mon, 10 Sep 2007 18:33:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: Micah Gruber <micah.gruber@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, gregkh@suse.de
Subject: Re: [PATCH] Remove pointless NULL pointer check in
	drivers/usb/storage/shuttle_usbat.c.
Message-ID: <20070910163307.GJ6892@kernel.dk>
References: <46DD1661.4070500@gmail.com> <20070904110651.GB5126@kernel.dk> <1188935869.19079.3.camel@odie.local> <20070904210630.GD4117@kernel.dk> <1189118009.19079.22.camel@odie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1189118009.19079.22.camel@odie.local>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07 2007, Simon Holm Thøgersen wrote:
> tir, 04 09 2007 kl. 23:06 +0200, skrev Jens Axboe:
> > On Tue, Sep 04 2007, Simon Holm Thøgersen wrote:
> > > tir, 04 09 2007 kl. 13:06 +0200, skrev Jens Axboe:
> > > > On Tue, Sep 04 2007, Micah Gruber wrote:
> > > > > This patch fixes a potential null dereference bug where we dereference us before a null check. This patch simply moves the dereferencing after the null check.
> > > > > 
> > > > > Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
> > > > 
> > > > Be careful with stuff like that, if you actually look at the code, a us
> > > > == NULL doesn't seem to be possible (or usbat_flash_transport() would
> > > > have oopsed before).
> > > > 
> > > If that is true, then
> > >         if (!us)
> > >                 return USB_STOR_TRANSPORT_ERROR;
> > > is utterly pointless.
> > 
> > Well that was the point I was trying to make, that test and return
> > should be deleted instead.
> > 
> I guess we agree that we want the following then.
> 
> 
> If us would ever be NULL, the function would have oopsed already before
> the check.

Yep, looks much better.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

> 
> Signed-off-by: Simon Holm Thøgersen <odie@cs.aau.dk>
> ---
> 
> --- a/drivers/usb/storage/shuttle_usbat.c
> +++ b/drivers/usb/storage/shuttle_usbat.c
> @@ -190,9 +190,6 @@ static int usbat_check_status(struct us_data *us)
>  	unsigned char *reply = us->iobuf;
>  	int rc;
>  
> -	if (!us)
> -		return USB_STOR_TRANSPORT_ERROR;
> -
>  	rc = usbat_get_status(us, reply);
>  	if (rc != USB_STOR_XFER_GOOD)
>  		return USB_STOR_TRANSPORT_FAILED;
> 
> 

-- 
Jens Axboe

