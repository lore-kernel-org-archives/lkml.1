Return-Path: <linux-kernel-owner+w=401wt.eu-S1762611AbYDSSut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762611AbYDSSut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 14:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbYDSSum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 14:50:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbYDSSul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 14:50:41 -0400
Date: Sat, 19 Apr 2008 14:48:36 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, mathieu.desnoyers@polymtl.ca
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080419184836.GB29968@redhat.com>
References: <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415155223.GA6935@in.ibm.com> <1208361092.6395.81.camel@twins> <y0m1w54cf82.fsf@ton.toronto.redhat.com> <1208501204.7115.60.camel@twins> <20080418142949.GB3922@redhat.com> <1208616747.6452.3.camel@lappy> <20080419180306.GA29968@redhat.com> <1208629769.6452.23.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208629769.6452.23.camel@lappy>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sat, Apr 19, 2008 at 08:29:27PM +0200, Peter Zijlstra wrote:
> [...]
> > OTOH I think this is a false dichotomy.  Debugging is not only done by
> > a subsystem maintainer during the merge/rc period.  When something
> > goes wrong on a deployed machine, problem diagnosis requires data,
> > which ideally should be gathered as non-intrusively as possible - that
> > means no recompiling / rebooting, and ideally very little slowdown.
> > [...]

> This again tries into the argument about not making markers depend on
> the code structure or implementation details.

It should not *unnecessarily* depend on those.

> I'm really wanting to avoid ever having to be obstructed by a marker. So
> any marker that does not represent a solid high level event (to take
> Mathieu's example: a context switch is a context switch, and we'll
> always have one) I'm not comfortable with merging that upstream.

It is your prerogative as a subsystem maintainer to make a guess about
this.  Others may make their own decisions differently, considering
the small costs and potential benefits.

> So even though these ad-hoc markers might have some diagnostic value
> - I'll never support merging them. If a customer might have some
> issue I can hand him a custom kernel with these markers added in - I
> see absolutely no reason to burden upstream with these.

Perhaps the kinds of bugs in your code, coupled with the kinds of
customers who experience those bugs, make tolerable this means of
diagnosis (requiring a reboot of their machines into a custom
debugging kernel).  The customers I have dealt with (and frankly, I
too) need to diagnose problems on a live running system as much as
possible.  They don't run every kernel du jour, so they don't need the
purely hypothetical tools that are dependent on a permanent set of
markers.
 

- FChE
