Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbXKUROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbXKUROU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 12:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbXKUROH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 12:14:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10890 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbXKUROE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 12:14:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ggCWnw2khOrBe0AZfCnHcrs5bUKvioSyEL2U6/v0GOqD3oAA3A5F/49W/LR5kNSjHQGaB/Emd/el/zBQ1jjjBAvgxYeI3FWiqKmi1NsRfqWGYjr2xiuvlvjtLtqwe3L+g3FlrLpk6yXc3Bg78zKWvBoBLnKya/hrXDNNIuu34pQ=
Message-ID: <d9def9db0711210914m47885980gffd789d30a817b88@mail.gmail.com>
Date: Wed, 21 Nov 2007 18:14:01 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] USB deadlock after resume
Cc: "Oliver Neukum" <oliver@neukum.org>,
       "Laurent Pinchart" <laurentp@cse-semaphore.com>,
       "Mark Lord" <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.44L0.0711211128380.3226-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0711210637x6fd5ad09o549b787639690d55@mail.gmail.com>
	 <Pine.LNX.4.44L0.0711211128380.3226-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 21 Nov 2007, Markus Rechberger wrote:
>
> > > > it's not just usb_set_interface that hangs actually.
> > > > It seems to hang at
> > > >
> > > > wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
> > > >
> > > > in drivers/usb/core/urb.c after resuming. I disabled access to the usb
> > > > subsystem in the uvc driver, although connecting any other usb storage
> > > > fails too, just at the same point.
> > >
> > > Which URB is usb_kill_urb() called for?
> > >
> >
> > it's the usb_control_message which calls usb_kill_urb if I haven't got
> > it wrong. (if you're looking for some other information please let me
> > know)
> > Although, I got a bit further with it. The error seems to happen
> > earlier already.
> > If I load the driver, and do not access the device after suspending
> > all usb_control commands fail with -71 eproto.
>
> That's very strange.  Getting -71 errors is understandable; it
> indicates that the device can't handle being suspended.  But the
> wait_event() line still shouldn't hang.  If it does, it indicates that
> there's something wrong with the USB host controller, not just the
> device.
>
> Can you try testing this on a different sort of computer?
>

Not really, suspending doesn't work at all on my other notebook it
just freezes..
I'm basically trying to get that driver work on my eee PC [1], it's
cheap and tiny so I don't expect anything special in there..
The system is preloaded with Xandros (it's debian etch with a few
custom applications) and linux 2.6.21.4.

The system still locks up, although only if I leave the video
application running during suspending. I don't have to reload the
driver anymore after resuming if the video node doesn't get accessed
(I'm looking for races in the uvc driver at the moment).

thanks,
Markus

[1] http://eeepc.asus.com
