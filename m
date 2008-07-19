Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYGSXCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYGSXCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 19:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYGSXB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 19:01:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:47924 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbYGSXBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 19:01:55 -0400
Date: Sat, 19 Jul 2008 15:58:17 -0700
From: Greg KH <gregkh@suse.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Dave Hansen <haveblue@us.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kernel-testers@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Bernhard Walle <bwalle@suse.de>
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068
	trace_hardirqs_on_caller
Message-ID: <20080719225817.GA6264@suse.de>
References: <20080718195352.e562a00f.sfr@canb.auug.org.au> <200807190928.33978.m.kozlowski@tuxland.pl> <19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com> <19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com> <20080719221723.GB5578@suse.de> <19f34abd0807191527u61c5ed61kffe2279c8d46915d@mail.gmail.com> <19f34abd0807191544nfd73be5nf7dde4b61992a7e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807191544nfd73be5nf7dde4b61992a7e8@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 12:44:38AM +0200, Vegard Nossum wrote:
> On Sun, Jul 20, 2008 at 12:27 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> >>> commit 0e3638d1e04040121af00195f7e4628078246489
> >>> Author: Dave Hansen <haveblue@us.ibm.com>
> >>> Date:   Thu Mar 16 17:30:16 2006 -0800
> >>>
> >>>     warn when statically-allocated kobjects are used
> >>>
> >>> ..which only exists in -next. Is that just a truly ancient patch, or
> >>> did somebody forget to adjust their clock?
> >>
> >> It is truely a very old patch, that only lives in my tree, and currently
> >> isn't planned to go to Linus any year soon.
> >>
> >> But it has a very long history of living in the -mm tree, and finding
> >> real bugs, it's just not "safe" enough to go to Linus's tree.  Unless
> >> you think it is?
> >
> > Hm. In this case, the patch is not even reporting a problem, it is in
> > fact in error itself.
> >
> > The problem is that it calls kzalloc() before the slab caches have
> > been set up. (Yes, it's a wonder that nothing crashed.) I can only
> > suggest the addendum
> >
> >    if (!slab_is_available())
> >        return;
> 
> Well, of course, it's also possible that the e820 code shouldn't be
> initializing kobjects this early in the first place.

That's probably the case, the kobject code isn't able to handle this
kind of thing (sysfs included).

> firmware_map_add_early() is using bootmem for the allocation. So yes,
> I guess it should possible to use kobjects here. That said, this code
> is in fact fairly recent:
> 
> commit 69ac9cd629ca96e59f34eb4ccd12d00b2c8276a7
> Author: Bernhard Walle <bwalle@suse.de>
> Date:   Fri Jun 27 13:12:54 2008 +0200
> 
>     sysfs: add /sys/firmware/memmap
> 
> I'll add the Cc. I still have a feeling that the kobject patch should
> expect to run even when slab is not available.

I never has been expected to do so in the past, so odds are, lots of
things might break :(

thanks,

greg k-h
