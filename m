Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYGNP5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYGNP5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYGNP5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:57:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34346 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753386AbYGNP5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:57:34 -0400
Date: Mon, 14 Jul 2008 11:57:33 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Johannes Berg <johannes@sipsolutions.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.26-rc9-git12: Reported regressions from 2.6.25
In-Reply-To: <1216044398.23746.10.camel@johannes.berg>
Message-ID: <Pine.LNX.4.44L0.0807141153110.2566-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008, Johannes Berg wrote:

> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11072
> > > > Subject		: scsi-layer crash after usb storage device unplug
> > > > Submitter	: Johannes Berg <johannes@sipsolutions.net>
> > > > Date		: 2008-07-12 01:50 (2 days old)
> > > > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> > > > Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11072#c3
> > > 
> > > Alan, Greg?
> > 
> > We haven't heard back yet from Johannes to confirm that the fix really
> > works.  If it does, IMO the patch should go into 2.6.26.1.
> > 
> > (In fact it might not be so easy to tell, since the failure is caused 
> > be a race.  Perhaps it would be best to submit the patch in any case.)
> 
> I haven't had a chance to apply the patch, but given that to cause the
> oops to happen I had to unplug/replug the device at random intervals for
> probably 10 minutes (yes, it took me that long to figure out I had put
> an SDHC card into an SD reader) I suppose it really won't be easy to
> tell.

Add

	printk(KERN_ALERT "Unplug now!\n");
	ssleep(10);

to the start of slave_configure() in drivers/usb/storage/scsiglue.c.  
Then it should be very easy to trigger the failure.  :-)

Assuming the failure does occur without the patch, see if it still 
occurs once the patch is in place.

Alan Stern

