Return-Path: <linux-kernel-owner+w=401wt.eu-S1761697AbYDOTUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761697AbYDOTUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 15:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbYDOTU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 15:20:29 -0400
Received: from mx1.suse.de ([195.135.220.2]:54647 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbYDOTU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 15:20:28 -0400
Date: Tue, 15 Apr 2008 12:13:33 -0700
From: Greg KH <gregkh@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: pci: add to global list before sysfs?
Message-ID: <20080415191333.GA28671@suse.de>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx> <20080404210132.GA14418@suse.de> <1208122538.6958.57.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208122538.6958.57.camel@pasglop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 07:35:38AM +1000, Benjamin Herrenschmidt wrote:
> 
> On Fri, 2008-04-04 at 14:01 -0700, Greg KH wrote:
> > As I mention above, the "global list" is now gone, so it's going to be
> > a
> > bit harder to do this.  We now only keep one list of all PCI devices,
> > and that is with the driver core mechanisms as the duplicate list was
> > just sitting there doing nothing for the past 4 years.
> > 
> > So is the problem that your driver need to bind to multiple pci
> > devices
> > at the same time in order to work properly?
> > 
> > Or is this just really broken hardware?
> 
> Haven't had a chance to look at your changes yet, but I have memories of
> being pretty happy with having that 2 step mechanism in PCI where the
> driver core would only see the devices after fixup.

No, that is left alone, I just dropped the duplicate device list that
was linked within the PCI devices themselves.  The only user of it was
the "reorder the PCI devices" code for some Dell machines, and that was
just doing it to be safe (it was also reordering the driver core list of
PCI devices, which is what really mattered.)

So everything should still be fine.

thanks,

greg k-h
