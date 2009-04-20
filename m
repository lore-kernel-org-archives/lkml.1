Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZDTIho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZDTIho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 04:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbZDTIh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 04:37:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46589 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbZDTIh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 04:37:28 -0400
Date: Mon, 20 Apr 2009 09:35:23 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Nigel Cunningham <ncunningham-lkml@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] PM/Suspend: Introduce two new platform callbacks to
	avoid breakage (Re: 900af0d breaks some embedded suspend/resume)
Message-ID: <20090420083523.GB16002@flint.arm.linux.org.uk>
References: <20090417231009.GB6900@flint.arm.linux.org.uk> <200904181626.10388.rjw@sisk.pl> <20090418144132.GC7148@flint.arm.linux.org.uk> <200904182047.48009.rjw@sisk.pl> <1240183907.8867.22.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240183907.8867.22.camel@nigel-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 09:31:47AM +1000, Nigel Cunningham wrote:
> >  	}
> >  
> > -	if (suspend_ops->prepare) {
> > -		error = suspend_ops->prepare();
> > +	if (suspend_ops->prepare_late) {
> > +		error = suspend_ops->prepare_late();
> >  		if (error)
> >  			goto Power_up_devices;
> >  	}
> 
> Doesn't this invalidate testing that's already been done? Drivers
> implementing prepare() (arm omap1, pxa, omap2, s3c and powerpc mpc52xx
> and lite5200) are now going to have it called pre device_power_down.

... which is the way it has always been done prior to the change which
broke stuff.  So this patch is putting the ordering back the way it was
which has been well proven to work on these platforms.

So we're not invalidating any testing.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
