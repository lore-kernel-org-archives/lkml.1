Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYGSWU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYGSWU6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 18:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYGSWUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 18:20:50 -0400
Received: from ns1.suse.de ([195.135.220.2]:45365 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbYGSWUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 18:20:49 -0400
Date: Sat, 19 Jul 2008 15:17:23 -0700
From: Greg KH <gregkh@suse.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Dave Hansen <haveblue@us.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kernel-testers@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068
	trace_hardirqs_on_caller
Message-ID: <20080719221723.GB5578@suse.de>
References: <20080718195352.e562a00f.sfr@canb.auug.org.au> <200807190928.33978.m.kozlowski@tuxland.pl> <19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com> <19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 02:59:12PM +0200, Vegard Nossum wrote:
> On Sat, Jul 19, 2008 at 11:55 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > What I don't get here is how SLUB can be used this early in the boot
> > process. Notice that this is still miles away from the
> >
> >    SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> >
> > line, which comes much later. And that kobject_init() _is_ calling
> > kzalloc() via verify_dynamic_kobject_allocation(). Isn't this an
> > error?
> >
> > (Unfortunately, my "git log" doesn't turn up any recent changes for
> > any of the affected code paths here.)
> 
> Ehe... and this is the reason why: The code was added by this patch:
> 
> commit 0e3638d1e04040121af00195f7e4628078246489
> Author: Dave Hansen <haveblue@us.ibm.com>
> Date:   Thu Mar 16 17:30:16 2006 -0800
> 
>     warn when statically-allocated kobjects are used
> 
> ..which only exists in -next. Is that just a truly ancient patch, or
> did somebody forget to adjust their clock?

It is truely a very old patch, that only lives in my tree, and currently
isn't planned to go to Linus any year soon.

But it has a very long history of living in the -mm tree, and finding
real bugs, it's just not "safe" enough to go to Linus's tree.  Unless
you think it is?

thanks,

greg k-h
