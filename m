Return-Path: <linux-kernel-owner+w=401wt.eu-S1161725AbXECKDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161725AbXECKDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161775AbXECKDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:03:30 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:60540 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161725AbXECKD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:03:29 -0400
Date: Thu, 3 May 2007 12:03:23 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Message-ID: <20070503100323.GA3278@gundam.enneenne.com>
References: <20070321074121.GA13843@enneenne.com> <20070502193314.GA23367@enneenne.com> <1178140014.7338.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178140014.7338.12.camel@localhost.localdomain>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 02:06:53PM -0700, john stultz wrote:
> 
> Please inline your patch, rather then attaching them. It makes it very
> difficult to discuss when it is attached.

Ok.

> > +++ b/drivers/pps/clients/ktimer.c
> > @@ -0,0 +1,106 @@
> > +/*
> > + * ktimer.c -- kernel timer test client
> > + *
> 
> Could you use a better name, like pps_ktimer_test.c, so it is less generic?

Ok. But consider that this is just a testing program.

> Same goes for your kabi.c and sysfs.c files.

Why? These files don't generate .ko files.

> > @@ -2004,6 +2004,8 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
> >  		up->ier |= UART_IER_MSI;
> >  	if (up->capabilities & UART_CAP_UUE)
> >  		up->ier |= UART_IER_UUE | UART_IER_RTOIE;
> > +	if (up->port.flags & UPF_HARDPPS_CD)
> > +		up->ier |= UART_IER_MSI;	/* enable interrupts */
> > 
> 
> This isn't covered by a #ifdef, so is this always safe? Should it be in
> a separate patch?

No, this part is regarding the serial driver itself. Maybe it can be
placed in a separate patch but it is still about the PPS support for
Linux...

> Unfortunately I don't have any hardware to play with this, but I'd
> suggest you send this to Andrew Morton for inclusion into his tree for
> testing.

I'll do it.

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
