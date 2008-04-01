Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYDAIiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYDAIiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbYDAIhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:37:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:56928 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbYDAIhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:37:55 -0400
Date: Tue, 1 Apr 2008 10:37:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 6)
Message-ID: <20080401083753.GA24983@atrey.karlin.mff.cuni.cz>
References: <200803292317.50218.rjw@sisk.pl> <200803292320.38378.rjw@sisk.pl> <200803300454.26318.rjw@sisk.pl> <200803312329.03455.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803312329.03455.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sunday, 30 of March 2008, Rafael J. Wysocki wrote:
> > On Saturday, 29 of March 2008, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Introduce 'struct pm_ops' and 'struct pm_ext_ops' representing
> > > suspend and hibernation operations for bus types, device classes and
> > > device types.
> > > 
> > > Modify the PM core to use 'struct pm_ops' and 'struct pm_ext_ops'
> > > objects, if defined, instead of the ->suspend() and ->resume() or,
> > > respectively, ->suspend_late() and ->resume_early() callbacks that
> > > will be considered as legacy and gradually phased out.
> > 
> > Unfortunately I forgot to set dev->power.status to DPM_PREPARING before
> > calling ->prepare(), as documented.  Also, dpm_prepare() could cleaned up
> > a bit.
> > 
> > Fixed patch follows.
> 
> My testing shows that some drivers tend to return error codes from their
> ->resume() callbacks, even though the devices in question appear to work
> correctly after the seemingly failing suspend.

The drivers should be fixed not to do that, no?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
