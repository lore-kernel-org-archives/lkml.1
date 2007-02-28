Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbXB1JoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbXB1JoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 04:44:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932100AbXB1JoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 04:44:03 -0500
Received: from mail.screens.ru ([213.234.233.54]:34448 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074AbXB1JoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 04:44:02 -0500
Date: Wed, 28 Feb 2007 12:43:46 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228094346.GA167@tv-sign.ru>
References: <200702272251.28844.rjw@sisk.pl> <20070227232855.GA457@tv-sign.ru> <200702280057.36198.rjw@sisk.pl> <20070228030726.GK29179@in.ibm.com> <20070228084859.GB104@tv-sign.ru> <20070228091053.GA15509@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228091053.GA15509@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Srivatsa Vaddagiri wrote:
>
> On Wed, Feb 28, 2007 at 11:48:59AM +0300, Oleg Nesterov wrote:
> > On 02/28, Srivatsa Vaddagiri wrote:
> > > We can just thaw the worker thread selectively before kthread_stopping
> > > them. This will let us freeze all worker threads (which we want to for
> > > hotplug anyway).
> > 
> > I am not sure this is a good change for 2.6.21.
> 
> So we make that change when merging the freezer-based hotplug patchset?
> 
> > I strongly believe it is better to change XFS so that it doesn't use
> > create_freezeable_workqueue() as Rafael suggested. 
> 
> Ok no issues. But when we enable freezer-based hotplug, we expect all
> non-singlethreaded worker threads to be frozen (for hotplug atleast).

Yes, we already discussed this :) This is btw another indication we
should kill create_freezeable_workqueue() eventually, so it would be
nice to change the only one user not to use it.

> > Besides, freezeable workqueues are buggy anyway in 2.6.21-rc,
> > 
> > 	http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755
> >
> > This means that workqueues become non-freezeable after suspend/resume
> > anyway (if I understand disable_nonboot_cpus() correctly).
> 
> Ah ok. When is the above patch expected to be merged?

Oh, I don't know. Note that this particular patch makes little sense if
we change XFS now (because we have no other users), but we can't drop it,
this will break subsequent patches.

Oleg.

