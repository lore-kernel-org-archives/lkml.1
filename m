Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbZFVXB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbZFVXB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZFVXBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:01:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60886 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZFVXBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:01:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update 3] PM: Introduce core framework for run-time PM of I/O devices
Date: Tue, 23 Jun 2009 01:02:27 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <magnus.damm@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0906221222490.15425-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906221222490.15425-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906230102.29318.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Alan Stern wrote:
> On Mon, 22 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > Again, this boils down to how drivers decide to use the async 
> > > interface.  I can see justifications for both pm_request_resume_get 
> > > (which would always increment the counter) and pm_request_resume (which 
> > > would increment the counter only if a work item had to be queued).
> > 
> > OK, so this means we should provide both at the core level and let the drivers
> > decide which one to use.
> > 
> > I think in both cases the caller would be responsible for decrementing the
> > counter?
> 
> Sure.  They could call pm_runtime_put just once at the end of their
> runtime_resume method (assuming they used pm_request_resume), or they
> could call it at every place where some deferred work was finished 
> (assuming they used pm_request_resume_get).
> 
> > > Okay, we don't need it then.  I forgot to mention in the previous
> > > message that there also has to be a pm_runtime_del() routine, which
> > > should cancel pending workqueue items and set the counter to some high
> > > value so that no new items are added.
> > 
> > Should that be called by device_pm_remove()?  I think so.
> 
> Yes.  I suppose it could be named pm_runtime_remove.  Either would be 
> okay.

OK

I'm sending a new version of the $subject patch, containing these changes
among other things, in a new thread.

Best,
Rafael
