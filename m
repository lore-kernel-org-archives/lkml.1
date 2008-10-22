Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbYJVUsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbYJVUsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 16:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYJVUsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 16:48:12 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:33971 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbYJVUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 16:48:11 -0400
Date: Wed, 22 Oct 2008 22:48:01 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Message-ID: <20081022204800.GT4390@tekkaman>
References: <1224683240-15439-1-git-send-email-giometti@linux.it> <1224683240-15439-2-git-send-email-giometti@linux.it> <20081022174004.GB10587@kroah.com> <20081022111145.e5f3c632.akpm@linux-foundation.org> <20081022195245.GS4390@tekkaman> <20081022130150.00836eba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022130150.00836eba.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/2] Add c2 port support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 01:01:50PM -0700, Andrew Morton wrote:
> > > <wonders what local_irq_disable() is supposed to achieve on SMP>
> > 
> > The SMP is achieved by mutex_lock(), the local_irq_disable() is used
> > to avoid interructions in code execution. C2 port has very stringent
> > timings.
> 
> Please add code comments explaning this (unless I missed them).

Ok.

> > +	if (!ret)
> > +		return ERR_PTR(-ENOMEM);
> 
> 		^^ leaks c2dev

Fixed.

> > +	if (unlikely(!c2dev->dev)) {
> > +		ret = -ENOMEM;
> > +		goto error_device_create;
> > +	};
> 
>          ^

Fixed.

> > > What I haven't yet got my head around is this:
> > > 
> > >   Currently this code supports only flash programming through sysfs
> > >   interface but extensions shoud be easy to add.
> > > 
> > > is that really what we want to use sysfs for?  As the prime interface
> > > to a device driver (or is it a bus driver?) Didn't we used to use
> > > device nodes for that sort of thing?
> > 
> > I decided to use this interface since the C2 ports are simple and very
> > easy to manage with such files abstraction.
> 
> well..  what _is_ the implemented interface?  What alternatives were
> considered and why were they judged inappropriate?  What interfaces do
> any similar in-tree drivers use?

Well... main reasons in using sysfs support are:

* no more char devices and new ioctls to define,

* the microcontrollers on-board flash can be easily programmed by
using only the "echo" and "cat" commands, so no more tools are needed
and even simply busybox can be used.

> > Whould you like I repropose the code with the fixed issues for your
> > review?

I repost the code.

Thanks,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
