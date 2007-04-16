Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXDPHkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXDPHkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 03:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbXDPHkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 03:40:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50341 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932290AbXDPHj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 03:39:59 -0400
Date: Mon, 16 Apr 2007 09:39:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [AppArmor 39/41] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070416073940.GA2146@elf.ucw.cz>
References: <20070412090809.917795000@suse.de> <20070412090849.465428000@suse.de> <p733b35903l.fsf@bingen.suse.de> <200704151621.52906.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704151621.52906.agruen@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +
> > > +	/* get optional subprofiles */
> > > +	if (aa_is_nameX(e, AA_LIST, "hats")) {
> > > +		while (!aa_is_nameX(e, AA_LISTEND, NULL)) {
> > > +			struct aa_profile *subprofile;
> > > +			subprofile = aa_unpack_profile(e);
> > 
> > Is there any check that would guard the recursion from stack
> > overflow on malicious input?  
> 
> It's nice to check for consistency though, so we're adding that. Profile 
> loading is a trusted operation, at least so far, and so security wise we 
> don't actually have to care --- if loading an invalid profile can bring down 
> the system, then that's no worse than an arbitrary module that crashes the 
> machine. Not sure if there will ever be user loadable profiles; at least at 
> that point we had to care.

It is not a _security_ problem, but face it, mount("/very weird
filename") is not expected to crash the kernel, either. It is
quality-of-impelmentation problem.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
