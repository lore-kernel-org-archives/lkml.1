Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbZBJU0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbZBJU0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbZBJUZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:25:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50939 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbZBJUZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:25:53 -0500
Date: Tue, 10 Feb 2009 21:25:45 +0100
From: Pavel Machek <pavel@suse.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: kmalloc during suspend, was Re: PCI PM: Restore standard config
	registers of all devices early
Message-ID: <20090210202545.GG1382@ucw.cz>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021413040.3247@localhost.localdomain> <1233615423.18767.129.camel@pasglop> <200902030022.39396.rjw@sisk.pl> <1233623026.18767.148.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233623026.18767.148.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-02-03 12:03:46, Benjamin Herrenschmidt wrote:
> 
> > > (*) There are reasons to think that kmalloc/gfp should both silently
> > > turn into GFP_NOIO always while the suspend process is started, but
> > > that's somewhat a different subject. Rafael, did we ever act on that ?
> > > It's an old discussion we had but I don't know if we actually
> > > implemented anything.
> > 
> > We have the ->prepare(), ->complete() callbacks that, among other things,
> > can be used for allocating and freeing memory with GFP_KERNEL safely.
> 
> First, that's assuming drivers will be smart enough to figure that out.
> They won't, believe me.

For big alocations, I see no other way. If someone wants  100MB for
firmmware image...
 
> Then, as I said, this doesn't work in practice because there is no way
> drivers and/or underlying subsystems will start "remembering" when they
> are within a prepare/complete pair, and suddenly do allocations
> differently. That's just going to break.

They could set a flag in ->prepare()... but yes, drivers will get that
wrong.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
