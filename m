Return-Path: <linux-kernel-owner+w=401wt.eu-S1761801AbZLJVu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761801AbZLJVu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761792AbZLJVu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:50:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:33083 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761782AbZLJVu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:50:26 -0500
Date: Thu, 10 Dec 2009 13:49:34 -0800
From: Greg KH <gregkh@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch] drivers: Fix bogus 0 error return in device_add()
Message-ID: <20091210214934.GA30843@suse.de>
References: <20091210193057.799393067@linutronix.de> <20091210205623.GA29097@suse.de> <alpine.LFD.2.00.0912102158590.3089@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912102158590.3089@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 10:01:10PM +0100, Thomas Gleixner wrote:
> On Thu, 10 Dec 2009, Greg KH wrote:
> > On Thu, Dec 10, 2009 at 07:32:49PM -0000, Thomas Gleixner wrote:
> > > If device_add() is called with a device which does not have dev->p set
> > > up, then device_private_init() is called. If that succeeds, then the
> > > error variable is set to 0. Now if the dev_name(dev) check further
> > > down fails, then device_add() correctly terminates, but returns 0.
> > > That of course lets the driver progress. If later another driver uses
> > > this half set up device as parent then device_add() of the child
> > > device explodes and renders sysfs completely unusable.
> > > 
> > > Set the error to -EINVAL if dev_name() check fails.
> > 
> > That's a good catch, thanks.
> > 
> > Is anything currently triggering this?  Or did you just find it by
> > reading the code?
> 
> Hans-Juergen had a buggy vendor driver where init_name was not
> initialized. So the driver probing succeeded and after that a
> depending driver crashed somewhere in device_add().

Ick, bad code :(

Good to know it's not a problem with in-tree drivers, so I don't have to
add this to the -stable trees.

thanks,

greg k-h
