Return-Path: <linux-kernel-owner+w=401wt.eu-S932320AbYBVDNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbYBVDNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 22:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbYBVDNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 22:13:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42602 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbYBVDN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 22:13:29 -0500
Date: Fri, 22 Feb 2008 03:13:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: David Newall <davidn@davidnewall.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080222031315.GF27894@ZenIV.linux.org.uk>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> <m3tzk1q3rt.fsf@maximus.localdomain> <47BE2985.6020305@davidnewall.com> <20080222020615.GE27894@ZenIV.linux.org.uk> <m3myptsp8u.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3myptsp8u.fsf@maximus.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 03:23:45AM +0100, Krzysztof Halasa wrote:
> Al Viro <viro@ZenIV.linux.org.uk> writes:
> 
> > ... if your style is lousy.  I agree that situation with printks is
> > not normal in that respect and I certainly have no love for the
> > checkpatch nonsense, but pressure to keep the fucking nesting depth
> > low is a Good Thing(tm).
> 
> Indeed. Unfortunately it is orthogonal to the line length limit.

Not quite.  Add such things as choice of sane identifiers.  And sane use of
local variables, while we are at it - things like twenty lines of
	foobar[(index + 1) % BLAH]->spork.vomit[12]->field_name = <expr>;
with the only difference in the field_name, except for one line where
we have a typo and see 11 instead of intended 12, are responsible for quite
a few of such overruns.

IMO the line length overruns make good warnings.  Not as in "here's a cheap
way to get more changesets", but as in "that code might have other problems
nearby" kind of heuristics.
