Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbYAOWNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbYAOWNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756960AbYAOWNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:13:20 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:32850 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754208AbYAOWNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:13:19 -0500
Date: Tue, 15 Jan 2008 23:13:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch] auto-qa Kconfig
Message-ID: <20080115221321.GB1565@elf.ucw.cz>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071231121115.b7ae39e4.randy.dunlap@oracle.com> <20080112010528.GA1590@kroah.com> <20080114161150.GC15542@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114161150.GC15542@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-01-14 17:11:50, Ingo Molnar wrote:
> 
> * Greg KH <greg@kroah.com> wrote:
> 
> > > and that is after fixing (in some sense) the first CONFIG_BLOCK=n 
> > > problem with the patch below.  Please test lots of configs. and/or 
> > > use 'make randconfig' (automated, scripted, e.g., etc.). maybe check 
> > > Documentation/SubmitChecklist.  :)
> > 
> > Ingo seems to be saying that he has some kind of "automated" build 
> > system to do this kind of checking.  Ingo, did you ever post how you 
> > did this anywhere?  I have enough spare machines here that I should be 
> > able to set up something to test my stuff this way easier than doing 
> > it by hand all the time (as the above problem proves I do miss things 
> > :( )
> 
> the crux of it is this patch:
> 
>   http://redhat.com/~mingo/auto-qa-patches/Kconfig-qa.patch
> 
> (ontop of x86.git)
> 
> adjust your arch/x86/Kconfig.needed whitelist (should already work on 
> typical systems) and do a 'make randconfig'. Every config is supposed to 
> build and boot fine, including 'make allnoconfig' and 'make 
> allyesconfig'. And please let me know about any blacklist items as well. 
> (right now they are a bit hacky via a "depends on 0" line and a small 
> comment explaining why they are not suitable in a bzImage kernel.)

 config X86_ELAN
        bool "AMD Elan"
        depends on X86_32
+
+       # dangerous to boot on non-Elan CPUs
+       depends on 0
+
        help
          Select this for an AMD Elan processor.


Hmmm... Most options like "support 386" are of "add support for 386,
but do not break support for pentium". ELAN etc seem to be
exceptions. Perhaps options that _take away_ functionality (like ELAN
-- takes ability to boot on normal 386)  should be specifically marked
somehow?

depends on EXCLUSIVE_FEATURE

?

depends on NOT_A_FEATURE

?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
