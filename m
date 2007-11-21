Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbXKUOnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbXKUOnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 09:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbXKUOnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 09:43:01 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:62248 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbXKUOnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 09:43:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eFHTenZX0KfmVKGRbGiqfPLWHLw6c+r9jG+qA3W/4h3Dt30fGNgm4wheibQVCRGUuyCvFZ1hhQfPwwglug9lS0/oXVFFHukXwGCCP6syy2eu0JdyTjdcghuowtVfWr/I+B6wWbOdJTFNztmKM9cmYqGuOABae0zp9XG86Tu0Z3Q=
Message-ID: <d9def9db0711210642h23db950vdc0fe1b9802e3e8b@mail.gmail.com>
Date: Wed, 21 Nov 2007 15:42:43 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: USB deadlock after resume
Cc: "Mark Lord" <lkml@rtr.ca>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net,
       "Laurent Pinchart" <laurentp@cse-semaphore.com>
In-Reply-To: <d9def9db0711210637x6fd5ad09o549b787639690d55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0711201347u2786fe0ev96b2fb43fc2954e9@mail.gmail.com>
	 <d9def9db0711202132q2c5a9b46k79c00da68250db3b@mail.gmail.com>
	 <d9def9db0711210259v5d06590w7754aeb508632c77@mail.gmail.com>
	 <200711211246.39441.oliver@neukum.org>
	 <d9def9db0711210637x6fd5ad09o549b787639690d55@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> On 11/21/07, Oliver Neukum <oliver@neukum.org> wrote:
> > Am Mittwoch 21 November 2007 schrieb Markus Rechberger:
> > > On 11/21/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> > > > On 11/21/07, Mark Lord <lkml@rtr.ca> wrote:
> > > > > Markus Rechberger wrote:
> > > > > > Hi,
> > > > > >
> > > > > > I'm looking at the linux uvc driver, and noticed after resuming my
> > > > > ..
> > > > >
> > > > > Pardon me.. what is the "uvc" driver?  Which module/source file is
> > that?
> > > > >
> > > >
> > > > http://linux-uvc.berlios.de/ it's not yet included in the kernel
> > > > sources although many distributions already ship it.
> > > > A "dry" run putting the device into sleep mode works fine (I added a
> > > > proc interface for calling those suspend/resume function).
> > > >
> > >
> > > it's not just usb_set_interface that hangs actually.
> > > It seems to hang at
> > >
> > > wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);
> > >
> > > in drivers/usb/core/urb.c after resuming. I disabled access to the usb
> > > subsystem in the uvc driver, although connecting any other usb storage
> > > fails too, just at the same point.
> >
> > Which URB is usb_kill_urb() called for?
> >
>
> it's the usb_control_message which calls usb_kill_urb if I haven't got
> it wrong. (if you're looking for some other information please let me
> know)
> Although, I got a bit further with it. The error seems to happen
> earlier already.
> If I load the driver, and do not access the device after suspending
> all usb_control commands fail with -71 eproto.
>
> Reloading the driver doesn't help at tht point, only reconnecting the
> device does.
>
> The data is transfered using bulk transfer.
>

Do you know any good way for performing a softreset within the driver?
The video application should get a continuous datastream after
resuming the notebook, so the driver shouldn't be unloaded.
The driver also keeps a list of previous camera settings which should
be set up again after resuming. Stopping the video application and
reattaching the device using ACPI (this board supports reconnecting
the device using ACPI) should be avoided.

Markus
