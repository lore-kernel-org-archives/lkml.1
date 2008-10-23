Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbYJWQ1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbYJWQ1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbYJWQ1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:27:16 -0400
Received: from cnc.isely.net ([64.81.146.143]:33770 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349AbYJWQ1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:27:14 -0400
Date: Thu, 23 Oct 2008 11:27:11 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Greg KH <greg@kroah.com>
cc: Alan Stern <stern@rowland.harvard.edu>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Oliver Neukum <oliver@neukum.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Mike Isely at pobox <isely@pobox.com>
Subject: Re: Bug fix for pvrusb2 driver [was: Re: Kernel 2.6.26.5 -> 2.6.27.2
 [USB REGRESSION] (USB -> D_STATE)]
In-Reply-To: <20081020172914.GA9624@kroah.com>
Message-ID: <Pine.LNX.4.64.0810231114320.1475@cnc.isely.net>
References: <Pine.LNX.4.44L0.0810201203530.2719-100000@iolanthe.rowland.org>
 <Pine.LNX.4.64.0810201134400.12643@cnc.isely.net> <20081020172914.GA9624@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008, Greg KH wrote:

> On Mon, Oct 20, 2008 at 11:37:41AM -0500, Mike Isely wrote:
> > 
> > I was incomplete in my previous response.  See further below for nack 
> > and another patch...
> > 
> > 
> > On Mon, 20 Oct 2008, Alan Stern wrote:
> > 
> >    [...]
> > 
> > > 
> > > Index: usb-2.6/drivers/media/video/pvrusb2/pvrusb2-main.c
> > > ===================================================================
> > > --- usb-2.6.orig/drivers/media/video/pvrusb2/pvrusb2-main.c
> > > +++ usb-2.6/drivers/media/video/pvrusb2/pvrusb2-main.c
> > > @@ -68,6 +68,16 @@ static void pvr_setup_attach(struct pvr2
> > >  #endif /* CONFIG_VIDEO_PVRUSB2_SYSFS */
> > >  }
> > >  
> > > +static int pvr_pre_reset(struct usb_interface *intf)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > > +static int pvr_post_reset(struct usb_interface *intf)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > >  static int pvr_probe(struct usb_interface *intf,
> > >  		     const struct usb_device_id *devid)
> > >  {
> > > @@ -109,7 +119,9 @@ static struct usb_driver pvr_driver = {
> > >  	.name =         "pvrusb2",
> > >  	.id_table =     pvr2_device_table,
> > >  	.probe =        pvr_probe,
> > > -	.disconnect =   pvr_disconnect
> > > +	.disconnect =   pvr_disconnect,
> > > +	.pre_reset =	pvr_pre_reset,
> > > +	.post_reset =	pvr_post_reset,
> > >  };
> > >  
> > >  /*
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > Nacked-by: Mike Isely <isely@pobox.com>
> > 
> > There is already another patch ready to go which eliminates the reset 
> > entirely.  It can be found here:
> > 
> > http://linuxtv.org/hg/~mcisely/pvrusb2/rev/0bb411d8d2e4
> 
> Will this patch be sent to the -stable group, to fix this regression in
> 2.6.27?  Or should they take Alan's fix instead?
> 

Greg:

I didn't directly answer your question here because I had figured it was 
answered in a previous post on this thread, that Mike Krufky had already 
explicitly asked that it be queued (and added his Reviewed-By tag), and 
that I figured it best not to add yet more noise to an already noisy 
group.

However now I see that this patch didn't get into 2.6.27.3.  It's a 
pretty important fix; without it the pvrusb2 driver is worse than 
useless (unless one adds initusbreset=0 as a module option).

My POV for this process in the past is that I generate a stable fix at 
linuxtv.org, ensure that Mike Krufky and Mauro see the incoming change, 
and then it gets into the next stable release.  This is what I thought I 
did here, but the results are different - 2.6.27.3 still has the driver 
in a totally broken state.  Quite likely I missed something that caused 
the fix not to be pulled.  Is there anything I can do to ensure this get 
into 2.6.27.4?

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
