Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbYJTRdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbYJTRdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbYJTRcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:32:52 -0400
Received: from kroah.org ([198.145.64.141]:45262 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753395AbYJTRcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:32:50 -0400
Date: Mon, 20 Oct 2008 10:29:14 -0700
From: Greg KH <greg@kroah.com>
To: Mike Isely <isely@pobox.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Oliver Neukum <oliver@neukum.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: Bug fix for pvrusb2 driver [was: Re: Kernel 2.6.26.5 ->
	2.6.27.2 [USB REGRESSION] (USB -> D_STATE)]
Message-ID: <20081020172914.GA9624@kroah.com>
References: <Pine.LNX.4.44L0.0810201203530.2719-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0810201134400.12643@cnc.isely.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810201134400.12643@cnc.isely.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 11:37:41AM -0500, Mike Isely wrote:
> 
> I was incomplete in my previous response.  See further below for nack 
> and another patch...
> 
> 
> On Mon, 20 Oct 2008, Alan Stern wrote:
> 
>    [...]
> 
> > 
> > Index: usb-2.6/drivers/media/video/pvrusb2/pvrusb2-main.c
> > ===================================================================
> > --- usb-2.6.orig/drivers/media/video/pvrusb2/pvrusb2-main.c
> > +++ usb-2.6/drivers/media/video/pvrusb2/pvrusb2-main.c
> > @@ -68,6 +68,16 @@ static void pvr_setup_attach(struct pvr2
> >  #endif /* CONFIG_VIDEO_PVRUSB2_SYSFS */
> >  }
> >  
> > +static int pvr_pre_reset(struct usb_interface *intf)
> > +{
> > +	return 0;
> > +}
> > +
> > +static int pvr_post_reset(struct usb_interface *intf)
> > +{
> > +	return 0;
> > +}
> > +
> >  static int pvr_probe(struct usb_interface *intf,
> >  		     const struct usb_device_id *devid)
> >  {
> > @@ -109,7 +119,9 @@ static struct usb_driver pvr_driver = {
> >  	.name =         "pvrusb2",
> >  	.id_table =     pvr2_device_table,
> >  	.probe =        pvr_probe,
> > -	.disconnect =   pvr_disconnect
> > +	.disconnect =   pvr_disconnect,
> > +	.pre_reset =	pvr_pre_reset,
> > +	.post_reset =	pvr_post_reset,
> >  };
> >  
> >  /*
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> Nacked-by: Mike Isely <isely@pobox.com>
> 
> There is already another patch ready to go which eliminates the reset 
> entirely.  It can be found here:
> 
> http://linuxtv.org/hg/~mcisely/pvrusb2/rev/0bb411d8d2e4

Will this patch be sent to the -stable group, to fix this regression in
2.6.27?  Or should they take Alan's fix instead?

thanks,

greg k-h
