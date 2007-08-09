Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbXHISiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbXHISiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXHISiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:38:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46200 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbXHISiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:38:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Disk spin down issue on shut down/suspend to disk
Date: Thu, 9 Aug 2007 20:47:31 +0200
User-Agent: KMail/1.9.5
Cc: Tejun Heo <htejun@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       Michael Sedkowski <sedmich@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, Thomas Renninger <trenn@suse.de>
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no> <46B8140E.3000509@gmail.com> <20070809150634.GA3926@ucw.cz>
In-Reply-To: <20070809150634.GA3926@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708092047.32133.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 9 August 2007 17:06, Pavel Machek wrote:
> Hi!
> 
> > >> Oh... crap, so acpi wants to sync cache on shutdown.  I wonder whether
> > >> it spins down the disk correctly.  Does emergency unload count increase
> > >> after each power down?  Also, please post the result of 'dmidecode'.
> > > 
> > > I know that my Compaq X1000-series laptop does do some kind of ACPI
> > > games with the disk on ACPI power off (I assume it is putting the disk
> > > in standby before power-off at least). It also does this if you boot
> > > into DOS, GRUB, etc. and then hit the power button. Could be if the disk
> > > is dumb enough to spin up for sync cache and standby when there is
> > > nothing to flush, and the kernel does its own standby, this could cause
> > > an extra spinup/down..
> > 
> > Yeah, that seems to be what's going on.  I don't think we have any other
> > choice than blacklisting those notebooks.  This is a mess.  How does the
> > other OS cope with this?
> > 
> > I'm thinking about using DMI vendor/product match to detect the affected
> > systems but I think it would be better to match the ACPI implementation
> > directly.  Is there a way to match specific ACPI implementation?
> 
> Well.. unless they use some SMM trick, it is ACPI AML code telling
> kernel to spin the disk down. I guess we could detect that, and simply
> ignore the request.

Please see: http://lkml.org/lkml/2007/8/8/187

Greetings,
Rafael
