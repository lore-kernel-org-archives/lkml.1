Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbXJORed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbXJORed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbXJOReU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:34:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59218 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbXJOReS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:34:18 -0400
Date: Mon, 15 Oct 2007 10:33:57 -0700
From: Greg KH <greg@kroah.com>
To: Rob Landley <rob@landley.net>
Cc: Julian Calaby <julian.calaby@gmail.com>, Theodore Tso <tytso@mit.edu>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
Message-ID: <20071015173357.GB5738@kroah.com>
References: <200710112011.22000.rob@landley.net> <200710150304.00901.rob@landley.net> <646765f40710150206j75af4c4dwac4f4565451b64b1@mail.gmail.com> <200710150508.37332.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710150508.37332.rob@landley.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 05:08:36AM -0500, Rob Landley wrote:
> On Monday 15 October 2007 4:06:20 am Julian Calaby wrote:
> > On 10/15/07, Rob Landley <rob@landley.net> wrote:
> > > I note that the eth0 and eth1 names are dynamically assigned on a first
> > > come first serve basis (like scsi).  This never causes me a problem
> > > because the driver loading order is constant, and once you figure out
> > > that eth0 is gigabit and eth1 is the 80211g it _stays_ that way across
> > > reboots, reliably. Yeah, it's a heuristic.  Hands up everybody relying on
> > > such a heuristic in the real world.
> >
> > Umm, not quite, from my experiences with pre-production wireless
> > drivers, (another story, another time) fancy stuff is being done in
> > udev to make sure that your gigabit card is always assigned to eth0.
> 
> I remember building a 2.4 kernel, statically linking in all the drivers, and 
> getting the ethernet devices showing up in a reliable order for years.  Where 
> does the need for fancy stuff come in?

Because PCI devices reorder their bus numbers all the time.  And we have
ethernet devices hanging off of USB connections now (yes, even built-in
to the machine), and we have network connections on other hot-pluggable
busses (remember, PCI is hot pluggable.)

So, the distros need to name network devices in a persistant way, that
is why the distros now do this.  If you don't like the distro doing it,
complain to them, it's not a kernel issue :)

thanks,

greg k-h
