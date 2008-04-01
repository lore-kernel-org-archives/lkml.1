Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbYDATeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbYDATeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 15:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbYDATeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 15:34:07 -0400
Received: from mail.crca.org.au ([67.207.131.56]:49013 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758648AbYDATeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 15:34:03 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 6)
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>
In-Reply-To: <Pine.LNX.4.44L0.0804011029010.3993-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0804011029010.3993-100000@iolanthe.rowland.org>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Wed, 02 Apr 2008 06:34:27 +1100
Message-Id: <1207078467.23143.96.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2008-04-01 at 10:31 -0400, Alan Stern wrote:
> On Tue, 1 Apr 2008, Benjamin Herrenschmidt wrote:
> 
> > On Tue, 2008-04-01 at 19:15 +1100, Nigel Cunningham wrote:
> > > > + *   However, drivers may NOT assume anything about the availability of the
> > > > + *   user space at that time and it is not correct to request firmware from
> > > > + *   within @prepare() (it's too late to do that).
> > > 
> > > That doesn't sound good. It would be good to be able to get drivers to
> > > request firmware early in the process.
> > 
> > Agreed. Prepare() should still allow request_firmware and full userspace
> > communication / helper usage.
> 
> Pepare() is called after userspace has been frozen.  (Of course, once 
> the freezer goes away this won't matter any more.)
> 
> There is a separate notifier chain which drivers can subscribe to;
> notifications about impending sleeps are sent out while userspace is
> still alive.  Drivers can use that for request_firmware, memory
> allocation, and other things.

Then that should be mentioned here so that drivers authors can know that
it is possible to request firmware, allocate memory and so on at a stage
when you can still rely on userspace being alive.

Regards,

Nigel

