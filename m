Return-Path: <linux-kernel-owner+w=401wt.eu-S1760695AbYDAVe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695AbYDAVe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758198AbYDAVeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:34:50 -0400
Received: from mail.crca.org.au ([67.207.131.56]:53679 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757415AbYDAVes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:34:48 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 6)
From: Nigel Cunningham <ncunningham@crca.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Oliver Neukum <oliver@neukum.org>
In-Reply-To: <200804012212.48609.rjw@sisk.pl>
References: <200803292317.50218.rjw@sisk.pl>
	 <200803312329.03455.rjw@sisk.pl> <1207037741.23143.81.camel@nigel-laptop>
	 <200804012212.48609.rjw@sisk.pl>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Wed, 02 Apr 2008 08:35:13 +1100
Message-Id: <1207085713.23143.111.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael etc.

On Tue, 2008-04-01 at 22:12 +0200, Rafael J. Wysocki wrote:
> 'ext' means 'extended'.  The idea is that the 'extended' version will be used
> by bus types / driver types that don't need to implement the _noirq callbacks.
> Both the platform and PCI bus types generally allow drivers to use _noirq
> callbacks, so they use 'struct pm_ext_ops', as well as their corresponding
> driver types.

Do you mean to say in the first sentence "...that _do_ need to
implement..."? If not, then extended sounds like a misnomer and the two
sentences seem to contradict one another.

[...]

> > > + *	However, drivers may NOT assume anything about the availability of the
> > > + *	user space at that time and it is not correct to request firmware from
> > > + *	within @prepare() (it's too late to do that).
> > 
> > That doesn't sound good. It would be good to be able to get drivers to
> > request firmware early in the process.
> 
> That will be possible when we drop the freezer.

Yeah, but right now, it seems to me to be a bogus limitation for drivers
to have no way of automatically loading firmware when you're about to
hibernate. (Of course I've since been reminded of the notifier chain -
that should probably be mentioned here as the way of achieving this).

By the way, I'm going to go on record now as saying I think dropping the
freezer is a silly idea. I'm therefore currently considering including
the freezer in TuxOnice from the time it gets dropped from mainline. I
know that will only make it less likely that TuxOnIce gets merged, but
I've given up caring about that anyway - caring about merging is
pointless when the people who decide if it gets merged don't care.

Regards,

Nigel

