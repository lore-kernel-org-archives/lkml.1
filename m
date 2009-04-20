Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbZDTIsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbZDTIsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 04:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZDTIsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 04:48:17 -0400
Received: from mail.crca.org.au ([67.207.131.56]:48198 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbZDTIsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 04:48:16 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH] PM/Suspend: Introduce two new platform callbacks to
 avoid breakage (Re: 900af0d breaks some embedded suspend/resume)
From: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Reply-To: ncunningham-lkml@crca.org.au
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
In-Reply-To: <20090420083523.GB16002@flint.arm.linux.org.uk>
References: <20090417231009.GB6900@flint.arm.linux.org.uk>
	 <200904181626.10388.rjw@sisk.pl>
	 <20090418144132.GC7148@flint.arm.linux.org.uk>
	 <200904182047.48009.rjw@sisk.pl> <1240183907.8867.22.camel@nigel-laptop>
	 <20090420083523.GB16002@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 18:48:27 +1000
Message-Id: <1240217307.8867.53.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2009-04-20 at 09:35 +0100, Russell King wrote:
> On Mon, Apr 20, 2009 at 09:31:47AM +1000, Nigel Cunningham wrote:
> > >  	}
> > >  
> > > -	if (suspend_ops->prepare) {
> > > -		error = suspend_ops->prepare();
> > > +	if (suspend_ops->prepare_late) {
> > > +		error = suspend_ops->prepare_late();
> > >  		if (error)
> > >  			goto Power_up_devices;
> > >  	}
> > 
> > Doesn't this invalidate testing that's already been done? Drivers
> > implementing prepare() (arm omap1, pxa, omap2, s3c and powerpc mpc52xx
> > and lite5200) are now going to have it called pre device_power_down.
> 
> ... which is the way it has always been done prior to the change which
> broke stuff.  So this patch is putting the ordering back the way it was
> which has been well proven to work on these platforms.
> 
> So we're not invalidating any testing.

Ah, okay. I didn't look at anything but current HEAD. :)

Nigel

