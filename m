Return-Path: <linux-kernel-owner+w=401wt.eu-S966192AbXHIPJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966192AbXHIPJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966202AbXHIPIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:08:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3175 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966187AbXHIPIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:08:50 -0400
Date: Thu, 9 Aug 2007 15:06:35 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <htejun@gmail.com>
Cc: Robert Hancock <hancockr@shaw.ca>, Michael Sedkowski <sedmich@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Subject: Re: Disk spin down issue on shut down/suspend to disk
Message-ID: <20070809150634.GA3926@ucw.cz>
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no> <fa.mg6p0itaOQUo/t8deCaYpyqj6Nk@ifi.uio.no> <fa.RxWYL8z8KktgL8LGZ/cTB2nI1Yc@ifi.uio.no> <fa.AyyCtZ2yLjC5noHPHtmzn4ffhhE@ifi.uio.no> <fa.SuAjism+m0z0haqCRVjkc2S978o@ifi.uio.no> <fa.QgWcLG2hfRb92g4blN61qYfRjlQ@ifi.uio.no> <46B7AF53.1040307@shaw.ca> <46B8140E.3000509@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B8140E.3000509@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Oh... crap, so acpi wants to sync cache on shutdown.  I wonder whether
> >> it spins down the disk correctly.  Does emergency unload count increase
> >> after each power down?  Also, please post the result of 'dmidecode'.
> > 
> > I know that my Compaq X1000-series laptop does do some kind of ACPI
> > games with the disk on ACPI power off (I assume it is putting the disk
> > in standby before power-off at least). It also does this if you boot
> > into DOS, GRUB, etc. and then hit the power button. Could be if the disk
> > is dumb enough to spin up for sync cache and standby when there is
> > nothing to flush, and the kernel does its own standby, this could cause
> > an extra spinup/down..
> 
> Yeah, that seems to be what's going on.  I don't think we have any other
> choice than blacklisting those notebooks.  This is a mess.  How does the
> other OS cope with this?
> 
> I'm thinking about using DMI vendor/product match to detect the affected
> systems but I think it would be better to match the ACPI implementation
> directly.  Is there a way to match specific ACPI implementation?

Well.. unless they use some SMM trick, it is ACPI AML code telling
kernel to spin the disk down. I guess we could detect that, and simply
ignore the request.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
