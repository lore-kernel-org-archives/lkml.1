Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZCKELb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZCKELb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 00:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbZCKELU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 00:11:20 -0400
Received: from kroah.org ([198.145.64.141]:41180 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750851AbZCKELS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 00:11:18 -0400
Date: Tue, 10 Mar 2009 21:07:30 -0700
From: Greg KH <greg@kroah.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-next@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: NCR_700_detect warnings
Message-ID: <20090311040730.GA29678@kroah.com>
References: <Pine.LNX.4.64.0903102139150.20676@anakin> <d82e647a0903101859p1cc2adf6s375b389907a31b82@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d82e647a0903101859p1cc2adf6s375b389907a31b82@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 09:59:09AM +0800, Ming Lei wrote:
> 2009/3/11 Geert Uytterhoeven <geert@linux-m68k.org>:
> > commit 76afea5b078d36ec080a75c29ff5a3fbc5774fee
> > Author: Ming Lei <tom.leiming@gmail.com>
> > Date:   Fri Feb 6 23:40:12 2009 +0800
> >
> >    platform driver: fix incorrect use of 'platform_bus_type' with 'struct devic
> >
> >    This patch fixes the bug reported in
> >        http://bugzilla.kernel.org/show_bug.cgi?id=11681.
> >
> >    "Lots of device drivers register a 'struct device_driver' with
> >    the '.bus' member set to '&platform_bus_type'. This is wrong,
> >    since the platform_bus functions expect the 'struct device_driver'
> >    to be wrapped up in a 'struct platform_driver' which provides
> >    some additional callbacks (like suspend_late, resume_early).
> >    The effect may be that platform_suspend_late() uses bogus data
> >    outside the device_driver struct as a pointer pointer to the
> >    device driver's suspend_late() function or other hard to
> >    reproduce failures."(Lothar Wassmann)
> >
> >    Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> >    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> >    Acked-by: David Brownell <dbrownell@users.sourceforge.net>
> >    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >
> > This introduced the following warnings on m68k, as `dev' is now a
> > `struct platform_device *' instead of a `struct device *':
> >
> > | drivers/scsi/a4000t.c:64: warning: passing argument 3 of 'NCR_700_detect' from incompatible pointer type
> > | drivers/scsi/mvme16x_scsi.c:67: warning: passing argument 3 of 'NCR_700_detect' from incompatible pointer type
> > | drivers/scsi/bvme6000_scsi.c:61: warning: passing argument 3 of 'NCR_700_detect' from incompatible pointer type
> >
> > I think the below is missing (untested on real hardware)?
> 
> Yes, you are correct. It is really missed.

Great, Geert, care to resend with a signed-off-by: so I can apply this?

thanks,

greg k-h
