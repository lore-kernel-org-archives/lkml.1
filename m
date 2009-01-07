Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZAGJnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZAGJnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 04:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbZAGJnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 04:43:32 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53233 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753065AbZAGJnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 04:43:31 -0500
Date: Wed, 7 Jan 2009 03:43:28 -0600
From: Robin Holt <holt@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, Robin Holt <holt@sgi.com>,
       "Luck, Tony" <tony.luck@intel.com>, Dimitri Sivanich <sivanich@sgi.com>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Gregory Haskins <ghaskins@novell.com>, Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH] configure HAVE_UNSTABLE_SCHED_CLOCK for SGI_SN systems
Message-ID: <20090107094328.GD3850@sgi.com>
References: <20090106162741.GA7991@sgi.com> <57C9024A16AD2D4C97DC78E552063EA35CB95575@orsmsx505.amr.corp.intel.com> <20090106201950.GA3850@sgi.com> <57C9024A16AD2D4C97DC78E552063EA35CB955B4@orsmsx505.amr.corp.intel.com> <1231275441.11687.110.camel@twins> <20090106225054.GB3850@sgi.com> <1231283763.11687.135.camel@twins> <20090107030030.GH3390@wotan.suse.de> <1231313289.11687.172.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231313289.11687.172.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 08:28:09AM +0100, Peter Zijlstra wrote:
> That's basically what the HAVE_UNSTABLE_SCHED_CLOCK code does. It takes
> a tick timestamp and tries to improve on that by using strict per cpu
> sched_clock() deltas.
> 
> What we do to obtain remote time, is basically calculate local time and
> pull remote time fwd if that was behind.

But what happens when the remote clock then takes a single tick and
pulls forward a different remote clock by both your tick and its tick.
Multiply that by 4096 and I am starting to feel that time is likely to
go racing forward in a really random fashion.

> While doing that, it filters out any backward motion and large fwd leaps
> so as to stay no worse than a jiffie clock.
