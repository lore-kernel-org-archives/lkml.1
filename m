Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbYDNA7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbYDNA7Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYDNA7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:59:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38383 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbYDNA7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:59:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 02:59:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Nigel Cunningham <ncunningham@crca.org.au>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0804131916420.3060-100000@netrider.rowland.org> <200804140207.19340.rjw@sisk.pl> <1208133631.6958.85.camel@pasglop>
In-Reply-To: <1208133631.6958.85.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140259.20962.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Benjamin Herrenschmidt wrote:
> 
> > Please have a look at this thread:
> > http://lkml.org/lkml/2008/3/21/322
> > (in short, the reporter sees APM suspend breakage under stress, occuring
> > because APM uses our suspending of devices without the freezer).
> > 
> > It mostly appears to work without the freezer, but that's bacuse no one
> > actually does things that might break it.  I don't think we can rely on users
> > being so kind to us forever. :-)
> 
> As far as I'm concerned, it's yet another case of the freezer papering
> over a problem rather than fixing it properly.

Well, this is not a user's point of view.

> If we're going to introduce new callbacks, we should have the right
> semantic from day 1 -and- fix those problems, rather than going to the
> same old recursive nonsensical arguments and do things to paper over
> problems.

Still, we're not supposed to break things, as far as the functionality is
concerned, and that's important, because it means we _have_ _to_ make changes
in steps.

To be more precise, what you suggest (move ->prepare() before the freezer
right now) means a patch with _functional_ changes (it's impossible to register
new children of dev after ->prepare(dev) has run which can affect the user
space in the window before ->prepare() and the freezer), whereas what I'd like
to do is the (present) patch without functional changes.

Thanks,
Rafael
