Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbYHRDwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbYHRDwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 23:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYHRDvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 23:51:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:34760 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYHRDvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 23:51:53 -0400
Date: Sun, 17 Aug 2008 20:50:37 -0700
From: Greg KH <greg@kroah.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH/RFC] pci: dynids.use_driver_data considered harmful
Message-ID: <20080818035037.GC30843@kroah.com>
References: <for-27-patch1-0@bga.com> <200808151046.59590.jbarnes@virtuousgeek.org> <20080815205500.1945916f@hyperion.delvare> <200808151215.02499.jbarnes@virtuousgeek.org> <20080816062259.GB20541@kroah.com> <20080817210659.06601a3b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080817210659.06601a3b@hyperion.delvare>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 09:06:59PM +0200, Jean Delvare wrote:
> Hi all,
> 
> On Fri, 15 Aug 2008 23:22:59 -0700, Greg KH wrote:
> > On Fri, Aug 15, 2008 at 12:15:01PM -0700, Jesse Barnes wrote:
> > > On Friday, August 15, 2008 11:55 am Jean Delvare wrote:
> > > > In fact we can do even better than that. We could accept from
> > > > user-space only driver_data values which at least one device ID entry in
> > > > the driver already uses. That should be fairly easy to implement, and
> > > > would offer a level of safety an order of magnitude above what we have
> > > > at the moment... And it works both ways: if 0 is not a valid data for
> > > > some driver, that would force the user to provide a non-zero (and
> > > > valid) data value. And it guarantees that the user can't ask for
> > > > something the driver doesn't expect, so drivers don't even need extra
> > > > checks. And no need for a use_driver_data flag either.
> > > 
> > > Meaning a driver audit of the usage?  Yeah that would be great.
> > > 
> > > > The only drawback is that it prevents the user from passing a "new"
> > > > data value even if it would be valid. But honestly, I don't expect that
> > > > case to happen frequently... if ever at all. So I'd say the benefits
> > > > totally outweight the drawback.
> > > >
> > > > If the interested people agree with the idea, I'll look into
> > > > implementing it.
> > > 
> > > Well the audit would show if user supplied "new" values are needed; otherwise 
> > > the approach sounds good to me.
> > 
> > That sounds reasonable, and should work properly.
> > 
> > No objection from me.
> 
> Ok, here's what it could look like:
> 
> * * * * *
> 
> From: Jean Delvare <khali@linux-fr.org>
> Subject: PCI: Check dynids driver_data value for validity
> 
> Only accept dynids those driver_data value matches one of the driver's
> pci_driver_id entry. This prevents the user from accidentally passing
> values the drivers do not expect.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Milton Miller <miltonm@bga.com>
> Cc: Greg KH <greg@kroah.com>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Looks good, thanks for sticking with it and creating this.

greg k-h
