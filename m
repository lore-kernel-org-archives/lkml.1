Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbXI1Qug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbXI1Qug (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbXI1Qu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:50:28 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52152 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbXI1Qu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:50:27 -0400
Date: Fri, 28 Sep 2007 18:51:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.10
Message-ID: <20070928165155.GA8760@uranus.ravnborg.org>
References: <bf97f66cfc0696c8574921d53eaafcb7@pinky> <20070928084003.GA18882@elte.hu> <20070928020132.f6c6f528.akpm@linux-foundation.org> <20070928092235.GA31180@shadowen.org> <20070928093902.GA28455@elte.hu> <20070928100024.GB18163@shadowen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928100024.GB18163@shadowen.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy.
> I think it is clear that we differ on what should and should not be
> output by default.  Clever people are able to opt out of the warnings,
> of things they think they dissagree with.  It is the people with little
> experience who need the most guidance and those people who the tool
> should target by default.  You cannot expect someone with no experience
> to know they need to add '--i-need-more-help' whereas _you_ I can expect
> to say '--leave-me-alone' or indeed to make the call that the output is
> plain wrong and _you_ know you should ignore it.

The original purpose was to catch the most tivial coding style errors.
But then people started to be far too innovative and we now ended
up with a checkpatch that try to check for every lillte glory detail.

It would be much preferable to have a checkpatch - and that may be an
incarnation of the current one or a new one.
What it should do would be to catch the trivialities that we see happens
in many patch submissions like:

a) wrong patch format (-p1, unified diff)
b) Whitespace versus tabs
c) PascalCasing in new functions
d) excessive line length
e) C99 comments '//' (not that I see why they are banned)

and maybe a few more trivial chacks.

This would benefit from a very low false-positive rate and it could then
be used as a patch-bot.

As it is now where it tries to check for everything and a bit more
it generates too much noise so a patch-bot usage is not possible.
And users get annoyed by the excessive output.

If we then have the same script that in a -pedantic mode generate
more noise - fine. But leave the default simple.

	Sam
