Return-Path: <linux-kernel-owner+w=401wt.eu-S1763518AbXFAStp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763518AbXFAStp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762137AbXFAStj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:49:39 -0400
Received: from waste.org ([66.93.16.53]:42917 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762122AbXFASti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:49:38 -0400
Date: Fri, 1 Jun 2007 13:49:13 -0500
From: Matt Mackall <mpm@selenic.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/9] Conditional Calls - Hash Table
Message-ID: <20070601184913.GB11115@waste.org>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.398040643@polymtl.ca> <p731wgxds85.fsf@bingen.suse.de> <20070601160802.GL11166@waste.org> <20070601164623.GB4112@Krystal> <20070601170739.GA11115@waste.org> <20070601174510.GG7217@one.firstfloor.org> <20070601180654.GB7641@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601180654.GB7641@Krystal>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 02:06:54PM -0400, Mathieu Desnoyers wrote:
> * Andi Kleen (andi@firstfloor.org) wrote:
> > > It's not clear to me why either of those things are necessary. An
> > > example please?
> > 
> > It's certainly possible that a global flag would need to be tested
> > more than once.
> > 
> > I guess it would work if a symbol is associated with a single
> > definition. e.g. if there is a DEFINE_COND_CALL() somewhere
> > and the individual cond calls reference it.
> 
> Yes, but as you have probably understood, I want to have everything
> embedded at the cond_call() site rather than polluting the rest of the
> code with declarations.

And you do so at the expensive of the ability to have compile-time
checks and the need to jump through a hash table at run-time. This
doesn't seem like a good trade-off.

Even if we -don't- do something like DEFINE_COND_CALL, it's still
probably a good idea to not use raw strings inline and to instead use
#defines. Raw strings are only slightly better than magic numbers.

> Also, if we have the same cond_calls in different modules, in which
> module shall it be defined ?

This isn't a new problem. It exists for every other type of object in
the kernel.

-- 
Mathematics is the supreme nostalgia of our time.
