Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYACK4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYACK4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 05:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYACK4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 05:56:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33550 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYACK4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 05:56:09 -0500
Date: Thu, 3 Jan 2008 11:56:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended
	(rev. 2)
Message-ID: <20080103105615.GC1732@elf.ucw.cz>
References: <200801020032.45529.rjw@sisk.pl> <200801021356.59865.rjw@sisk.pl> <20080102131529.GA32160@elte.hu> <200801021428.25164.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801021428.25164.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > That way any suspend breakage would be detectable (and bisectable) 
> > > > in automated testing - if the resume does not come back after 10-20 
> > > > seconds then the test failed.
> > > 
> > > Yes, but please note that some systems require user space 
> > > manipulations of the graphics adapter for suspend to work and to 
> > > detect a breakage of such a system you need to boot it into X and use 
> > > s2ram to suspend.
> > 
> > yeah, i wouldnt expect graphics mode to come back without quirks. But it 
> > should still work fine over the network, right? (which is my main mode 
> > of testing anyway)
> 
> Well, if the graphics is sufficiently broken, it won't resume at
> all.

Actually, no. Unless you try to boot the bios, it should come up
without graphics. 

Hmm... first framebuffer access may kill the machine at that
point... so disable framebuffer...? ;-). 

vga=1 and no acpi_sleep options usually does the trick for me. That
should work everywhere, independend of graphics options, AFAICT.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
