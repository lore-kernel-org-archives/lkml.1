Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbXFRFfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbXFRFfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 01:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXFRFfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 01:35:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47036 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbXFRFfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 01:35:23 -0400
Date: Sun, 17 Jun 2007 22:34:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] make hdrscheck.sh force __asm__ in exported headers
Message-Id: <20070617223436.2125b1a4.akpm@linux-foundation.org>
In-Reply-To: <200706180117.46809.vapier@gentoo.org>
References: <200706171854.24763.vapier@gentoo.org>
	<20070617221140.f1564f92.akpm@linux-foundation.org>
	<200706180117.46809.vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 01:17:46 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> On Monday 18 June 2007, Andrew Morton wrote:
> > On Sun, 17 Jun 2007 18:54:24 -0400 Mike Frysinger <vapier@gentoo.org> wrote:
> > > This updates scripts/hdrschecks.sh by grepping for asm() constructs and
> > > rejecting them in favor of __asm__() in exported headers.
> >
> > And does the kernel pass these checks?
> 
> nope ... should i audit the arches before this gets merged ?

Yes please.  I'd rather not break things in this fashion: it causes a storm
of emails which I need to redirect to the appropriate maintainers who then
take an arbitrarily long time to do anything.  Meanwhile lots of testers
get impacted and this reduces the testing level of all the other thousands
of patches in there.

> > Which architectures have been tested?
> 
> i386 passes, blackfin/x86_64 fail a simple asm/unistd.h, and x86_64 fails a 
> bunch in asm/msr.h, but last time i tried to patch that, the maintainer said 
> they were going to be hiding a bunch of that stuff anyways

Well I would prefer that we merge as many fixes as poss into -mm before
merging this patch - to reduce the impact on testers.

If these fixes are "wrong" but work then that's fine.  I just keep spamming
the maintainer with the wrong-but-works patch until he wakes up and fixes
it for real.


Also, your changelog sucks:

  This updates scripts/hdrschecks.sh by grepping for asm() constructs and
  rejecting them in favor of __asm__() in exported headers.

well OK.  But for what reason?  We can see a lot of pain in this patch but
no gain.  The changelog should tell us what the benefit is, so we can make
informed tradeoff decisions.

