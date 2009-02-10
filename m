Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZBJUZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZBJUZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbZBJUZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:25:32 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50856 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbZBJUZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:25:31 -0500
Date: Tue, 10 Feb 2009 21:25:24 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Andreas Schwab <schwab@suse.de>,
       Len Brown <lenb@kernel.org>
Subject: Re: PCI PM: Restore standard config registers of all devices early
Message-ID: <20090210202524.GF1382@ucw.cz>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <alpine.LFD.2.00.0902021413040.3247@localhost.localdomain> <200902022333.51017.rjw@sisk.pl> <200902022356.33094.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902022356.33094.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I'll have a look at the ACPI thing.
> 
> Generally speaking, we'd need to run acpi_evaluate_object() with interrupts
> off.
> 
> There are two apparent problems with that, from a quick look:
> 
> * The ACPI_MTX_INTERPRETER mutex needs to be acquired, but we know we won't
>   need that mutex with interrupts off, so presumably we can work around this.

In such case we either need refrigerator, or we should grab
MTX_INTERPRETER before we start suspending, hmm.

> * Memory allocations with GFP_KERNEL are made, which is even worse, because
>   we really shouldn't do that during suspend _at_ _all_, even during the regular
>   ->suspend() with interrupts on, because there's not guarantee that swap will
>   will be available at that time.  So, for the sake of correctness, we should
>   get rid of the GFP_KERNEL from the ACPI code paths executed during
>   suspend-resume anyway.

Well, we have some small reserves for stuff like that...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
