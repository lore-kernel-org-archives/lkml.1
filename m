Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbZAGDQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbZAGDQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 22:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbZAGDQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 22:16:38 -0500
Received: from relay3.sgi.com ([192.48.171.31]:53208 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751562AbZAGDQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 22:16:37 -0500
Date: Tue, 6 Jan 2009 21:16:34 -0600
From: Jack Steiner <steiner@sgi.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Robin Holt <holt@sgi.com>,
       "Luck, Tony" <tony.luck@intel.com>, Dimitri Sivanich <sivanich@sgi.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>, Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
Message-ID: <20090107031633.GD103000@sgi.com>
References: <20090106162741.GA7991@sgi.com> <57C9024A16AD2D4C97DC78E552063EA35CB95575@orsmsx505.amr.corp.intel.com> <20090106201950.GA3850@sgi.com> <57C9024A16AD2D4C97DC78E552063EA35CB955B4@orsmsx505.amr.corp.intel.com> <1231275441.11687.110.camel@twins> <20090106225054.GB3850@sgi.com> <1231283763.11687.135.camel@twins> <20090107030030.GH3390@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107030030.GH3390@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 04:00:30AM +0100, Nick Piggin wrote:
> On Wed, Jan 07, 2009 at 12:16:03AM +0100, Peter Zijlstra wrote:
> > > 
> > > But doesn't scheduler tick advance the rq->clock?  Why do the others
> > > need to fiddle with a remote runqueue's clock?  When that cpu starts
> > > taking ticks again, it will update it's rq->clock field and start the
> > > processes.  I guess I am a lot underinformed about the new scheduler
> > > design.
> > 
> > We try to do better than tick based time accounting these days.
> 
> But if you contain the drift to within one tick, it shouldn't be much
> problem to just truncate negative deltas I would have thought? The
> time between events on different CPUs is pretty fuzzy at the ns level
> anyway, I think ;)

Unfortunately, not possible on SGI IA64 systems. The cpus on different
nodes (blades) are not required to be the same steppings or core
frequencies. Core frequencies within the SSI can differ by hundreds of
MHz (~25%).

(I don't recall if we support systems with mixed madison & montecito
processors. If so, IIRC, the itc frequencies of these differ by 4X
for the same core frequency).

--- jack

