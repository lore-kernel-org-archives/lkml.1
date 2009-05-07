Return-Path: <linux-kernel-owner+w=401wt.eu-S1761807AbZEGVCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761807AbZEGVCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZEGVCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:02:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbZEGVB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:01:59 -0400
Date: Thu, 7 May 2009 13:56:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: rientjes@google.com, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Message-Id: <20090507135615.e7db550d.akpm@linux-foundation.org>
In-Reply-To: <200905072238.14558.rjw@sisk.pl>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<200905072218.50782.rjw@sisk.pl>
	<alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com>
	<200905072238.14558.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 22:38:13 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday 07 May 2009, David Rientjes wrote:
> > On Thu, 7 May 2009, Rafael J. Wysocki wrote:
> > 
> > > OK, let's try with __GFP_NO_OOM_KILL first.  If there's too much disagreement,
> > > I'll use the freezer-based approach instead.
> > > 
> > 
> > Third time I'm going to suggest this, and I'd like a response on why it's 
> > not possible instead of being ignored.
> > 
> > All of your tasks are in D state other than kthreads, right?  That means 
> > they won't be in the oom killer (thus no zones are oom locked), so you can 
> > easily do this
> > 
> > 	struct zone *z;
> > 	for_each_populated_zone(z)
> > 		zone_set_flag(z, ZONE_OOM_LOCKED);
> > 
> > and then
> > 
> > 	for_each_populated_zone(z)
> > 		zone_clear_flag(z, ZONE_OOM_LOCKED);
> > 
> > The serialization is done with trylocks so this will never invoke the oom 
> > killer because all zones in the allocator's zonelist will be oom locked.
> > 
> > Why does this not work for you?
> 
> Well, it might work too, but why are you insisting?  How's it better than
> __GFP_NO_OOM_KILL, actually?
> 
> Andrew, what do you think about this?

I don't think I understand the proposal.  Is it to provide a means by
which PM can go in and set a state bit against each and every zone?  If
so, that's still a global boolean, only messier.
