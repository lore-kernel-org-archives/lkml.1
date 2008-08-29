Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbYH2Ra1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbYH2Ra1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYH2RaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:30:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53396 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbYH2RaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:30:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.27-rc4] rtc-cmos: wakes again from S5
Date: Fri, 29 Aug 2008 19:34:11 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Stefan.Becker@nokia.com
References: <200808281129.35611.david-b@pacbell.net> <20080828172206.5e083817.akpm@linux-foundation.org> <200808281732.57394.david-b@pacbell.net>
In-Reply-To: <200808281732.57394.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291934.12157.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 29 of August 2008, David Brownell wrote:
> On Thursday 28 August 2008, Andrew Morton wrote:
> > On Thu, 28 Aug 2008 11:29:35 -0700
> > David Brownell <david-b@pacbell.net> wrote:
> > 
> > > +	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(pdev))
> > 
> > erp, system_state is a pretty horrid thing.  It's a global with
> > relatively poorly defined transition conditions which have actually
> > changed over time.
> 
> True, but it's the best we've got for this kind of thing.

Exactly.

> Globals ... yeech.
> 
> 
> > It was not my greatest ever idea.  It was simple and expedient at the
> > time and expanded use of it was "discouraged" (rofl).
> > 
> > Is there no alternative?
> 
> My general belief is that there should be a set of predicates
> that drivers use to test whether or not the target system state
> satisfies various prerequisites.  Like whether a clock or power
> domain must be disabled, and so on.
> 
> In this specific case, a system_is_powering_down() predicate is
> the logical application of that policy to this problem.

Well, we still need to store that information somewhere and make it globally
available, this way or another.

The problem is actually deeper, because there are quirks that have to be
called in specific situations from within relatively low-level functions
(e.g. http://bugzilla.kernel.org/show_bug.cgi?id=8855#c36), so if there's
a better approach than using system_state for that, I'd like to use it. :-)

Thanks,
Rafael
