Return-Path: <linux-kernel-owner+w=401wt.eu-S1758176AbZLPNwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbZLPNwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 08:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbZLPNwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 08:52:13 -0500
Received: from kroah.org ([198.145.64.141]:43287 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756735AbZLPNwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 08:52:10 -0500
Date: Wed, 16 Dec 2009 05:45:38 -0800
From: Greg KH <greg@kroah.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: dm: sysfs add empty release function to avoid debug warning
Message-ID: <20091216134538.GA20857@kroah.com>
References: <200912151735.nBFHZ8XP018683@hera.kernel.org> <20091216004739.GB4898@kroah.com> <4B28AC09.2000302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B28AC09.2000302@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 10:44:41AM +0100, Milan Broz wrote:
> On 12/16/2009 01:47 AM, Greg KH wrote:
> > On Tue, Dec 15, 2009 at 05:35:08PM +0000, James Bottomley wrote:
> >> commit: d2bb7df8cac647b92f51fb84ae735771e7adbfa7
> >> From: Milan Broz <mbroz@redhat.com>
> >> Date: Thu, 10 Dec 2009 23:51:53 +0000
> >> Subject: [PATCH] dm: sysfs add empty release function to avoid debug warning
> >>
> >> This patch just removes an unnecessary warning:
> >>  kobject: 'dm': does not have a release() function,
> >>  it is broken and must be fixed.
> >>
> >> The kobject is embedded in mapped device struct, so
> >> code does not need to release memory explicitly here.
> > 
> 
> > Please, this is totally and completly wrong.  And if you feel that it is
> > needed, then your design is wrong and it needs to be fixed.
> 
> There are several places in kernel, where kobject have not defined release
> method. Yes, something is wrong here.

Where are those instances, becides the use of static kobjects, which is
being worked on?

That still does not make this change acceptable, it is incorrect.

> So quietly ignoring warning is ok? Why is not there BUG_ON(!release) then?

I was trying to be nice and not crash your machine and give you the
opportunity to fix it easily.

> The sysfs attributes here just represents attributes of block device object,
> this device is always removed before release here is called.

Then why use a kobject at all?  Your reference counting will be all
wrong if you use it incorrectly like this.

> So if there is preferred to do another alloc/free, no problem.

Please do.

Also, with the addition of this patch, your comments for the kobject are
now incorrect as well.

thanks,

greg k-h
