Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZEEWnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZEEWnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZEEWnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:43:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58892 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbZEEWnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:43:23 -0400
Date: Tue, 5 May 2009 15:37:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: rientjes@google.com, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Message-Id: <20090505153739.2cc9d244.akpm@linux-foundation.org>
In-Reply-To: <200905060019.36542.rjw@sisk.pl>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<200905050023.38064.rjw@sisk.pl>
	<alpine.DEB.2.00.0905041735590.24101@chino.kir.corp.google.com>
	<200905060019.36542.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009 00:19:35 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > > +			&& !processes_are_frozen()) {
> > >  		if (!try_set_zone_oom(zonelist, gfp_mask)) {
> > >  			schedule_timeout_uninterruptible(1);
> > >  			goto restart;
> > 
> > Cool, that looks like the semantics of __GFP_NO_OOM_KILL without requiring 
> > a new gfp flag.  Thanks.
> 
> Well, you're welcome.
> 
> BTW, I think that Andrew was actually right when he asked if I checked whether
> the existing __GFP_NORETRY would work as-is for __GFP_FS set and
> __GFP_NORETRY unset.  Namely, in that case we never reach the code before
> nopage: that checks __GFP_NORETRY, do we?
> 
> So I think we shouldn't modify the 'else if' condition above and check for
> !processes_are_frozen() at the beginning of the block below.

Confused.

I'm suspecting that hibernation can allocate its pages with
__GFP_FS|__GFP_WAIT|__GFP_NORETRY|__GFP_NOWARN, and the page allocator
will dtrt: no oom-killings.

In which case, processes_are_frozen() is not needed at all?
