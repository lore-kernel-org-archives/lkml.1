Return-Path: <linux-kernel-owner+w=401wt.eu-S965686AbXDBTGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965686AbXDBTGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 15:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965706AbXDBTGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 15:06:49 -0400
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:20738 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965686AbXDBTGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 15:06:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xweLiqXMeTLMJNQ8ZQ09ZbXUW2+9RT3Gj2WCgaWoElsiZmTMYwXeutiw3ZxSTf2Ctbkw27pTeDJsDDtOYWBzFMkQV+i0k0nq11rYuTaeb7dt+vxUBZylk4pkAr8ZsxB0FS98iVeKBETNAKo7CGz51tZo3if8eDl4q1REeSG9gTk=  ;
X-YMail-OSG: HBdjYLEVM1mJlCuwtWtyOz6SQ70kS5sm3gqVBQkN_ctd7gt1_QuZmN2KsRAbZk2cab4zZNoOww--
From: David Brownell <david-b@pacbell.net>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [patch 2.6.21-rc5-git 1/2] fix hotplug for legacy platform drivers
Date: Mon, 2 Apr 2007 09:39:51 -0700
User-Agent: KMail/1.7.1
Cc: Greg KH <gregkh@suse.de>, Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andres Salomon <dilinger@debian.org>
References: <200703311455.38490.david-b@pacbell.net> <20070402105553.GA12153@flint.arm.linux.org.uk>
In-Reply-To: <20070402105553.GA12153@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020939.52494.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 3:55 am, Russell King wrote:
> On Sat, Mar 31, 2007 at 02:55:38PM -0700, David Brownell wrote:
> > --- g26.orig/drivers/pcmcia/pxa2xx_mainstone.c	2007-03-30 16:44:04.000000000 -0700
> > +++ g26/drivers/pcmcia/pxa2xx_mainstone.c	2007-03-31 14:23:56.000000000 -0700
> > @@ -175,6 +175,8 @@ static int __init mst_pcmcia_init(void)
> >  	if (!mst_pcmcia_device)
> >  		return -ENOMEM;
> >  
> > +	/* REVISIT just statically allocate the device */
> > +	mst_pcmcia_device->dev.uevent_suppress = 0;
> 
> Such a comment indicates that you clearly do not understand why these
> platform devices are dynamically allocated.
> 
> These are modules.  If they were statically allocated, then you have a
> potential oops waiting to happen if you have the right ordering of user
> accesses to sysfs coupled with an inopportune unload of such a driver -
> the memory backing the platform device will be unexpectedly released
> resulting in an access to freed memory.

OK, so I consider that issue sufficiently revisited.  :)

