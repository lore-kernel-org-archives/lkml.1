Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbXHaVtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbXHaVtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbXHaVto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:49:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45331 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbXHaVto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:49:44 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 31 Aug 2007 17:38:34 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: maturity and status and attributes, oh my!
Message-ID: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  at the risk of driving everyone here totally bonkers, i'm going to
take one last shot at explaining what i was thinking of when i first
proposed this whole "maturity level" thing.  and, just so you know,
the major reason i'm so cranked up about this is that i'm feeling just
a little territorial -- i was the one who first started nagging people
to consider this idea, so i'm a little edgy when i see folks finally
giving it some serious thought but appearing to get ready to implement
it entirely incorrectly in a way that's going to ruin it irreparably
and make it utterly useless.

  this isn't just about defining a single feature called "maturity".
it's about defining a general mechanism so that you can add entirely
new (what i call) "attributes" to kernel features.  one attribute
could be "maturity", which could take one of a number of possible
values.  another could be "status", with the same restrictions.
heck, you could define the attribute "colour", and decide that various
kernel features could be labelled as (at most) one of "red", "green"
and "chartreuse."  that's what i mean by an "attribute", and
attributes would have two critical and non-negotiable properties:

1) they would be entirely orthogonal to one another, and
2) they can be assigned at most one of a pre-defined set of values


  that's it.  it's really that simple and simon's earlier patch i
think fits that almost perfectly.  now, back to the disagreement.

  it may be that some people had a different understanding of what was
meant by "maturity" than i did.  what *i* meant by that attribute is
a feature's current position in the normal software life cycle, and
that would be one of:

  experimental -> normal (stable) -> deprecated -> obsolete

  it's a natural progression and, at any point, a feature cannot
possibly have more than one maturity value.  it would be as absurd as
saying that someone was a teenager *and* was a twenty-something at the
same time.  not possible.  and restricting an attribute to a single
value makes definitions and processing *way* easier down the road.
(and note that a feature's maturity says *nothing* about its current
level of quality.  that's next.)

  another attribute can then be what i was calling "status" but could
also be called "quality".   *that* is where you could categorize a
feature as one of FLAKY, BROKEN and so on.  that's an entirely
independent categorization from maturity, which means you could have
features that were both experimental and flaky, or deprecated and
broken, or what have you.  and those settings would be done with
separate Kconfig directives:

config WHATEVER
	maturity DEPRECATED
	status BROKEN

  from a quick perusal, simon's patch looked pretty much dead-on
(except for that teeth-grinding maturity level of BROKEN :-).  but
other than that, it looked good, although i'll have to go back later
and look more closely.

  but i hope i've flogged this thoroughly to the point where people
can see what i'm driving at.  once you see (as in simon's patch) how
to add the first attribute, it's trivial to simply duplicate that code
to add as many more as you want.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
