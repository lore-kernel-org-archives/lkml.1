Return-Path: <linux-kernel-owner+w=401wt.eu-S936768AbYCSVQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936768AbYCSVQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761896AbYCST7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:59:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36155 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761901AbYCST7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:59:34 -0400
Date: Wed, 19 Mar 2008 10:15:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks
Message-ID: <20080319091526.GA1938@elf.ucw.cz>
References: <200803170020.55473.rjw@sisk.pl> <200803170022.30345.rjw@sisk.pl> <20080319005340.GC8298@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319005340.GC8298@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-03-18 17:53:40, Greg KH wrote:
> On Mon, Mar 17, 2008 at 12:22:29AM +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Introduce 'struct pm_ops' representing a set of suspend and
> > hibernation operations for bus types, device classes and device
> > types.
> 
> Ok, I must have missed the thread describing why we need to do this, so,
> why do we need to do this?  What is this going to buy us in the end
> after everything is changed?

That was rather long thread where Linus flamed us for having
everything in one "suspend" callback, selecting what to do by
pm_message_t parameter. It was kind of hard to miss ;-).
								Pavel


> > +struct pm_ops {
> > +#ifdef CONFIG_PM_SLEEP
> > +	int (*prepare)(struct device *dev);
> > +	void (*complete)(struct device *dev);
> > +#endif
> > +#ifdef CONFIG_SUSPEND
> > +	int (*suspend)(struct device *dev);
> > +	int (*resume)(struct device *dev);
> > +#endif
> > +#ifdef CONFIG_HIBERNATION
> > +	int (*freeze)(struct device *dev);
> > +	int (*thaw)(struct device *dev);
> > +	int (*poweroff)(struct device *dev);
> > +	int (*quiesce)(struct device *dev);
> > +	int (*restore)(struct device *dev);
> > +	int (*recover)(struct device *dev);
> > +#endif
> 
> 
> Don't ifdef stuff like this, it only causes ifdefs to be needed to the
> .c code as well for all places these structures are defined in
> drivers/busses, right?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
