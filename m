Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbXL3LB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbXL3LB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 06:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbXL3LBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 06:01:19 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:37897 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbXL3LBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 06:01:18 -0500
Date: Sun, 30 Dec 2007 13:01:11 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Message-ID: <20071230110111.GB31605@does.not.exist>
References: <20071228212341.GA6939@uranus.ravnborg.org> <200712292217.37474.ak@suse.de> <20071229214522.GG27360@does.not.exist> <200712300300.51427.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200712300300.51427.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2007 at 03:00:51AM +0100, Andi Kleen wrote:
> 
> > Without inlining the maxmimum stack usage inside foobar() is
> > max(stack usage foo(), stack usage bar()). [1]
> 
> It's a little more complicated. gcc 4.x (not sure which x, might 0) 
> is clever enough to not use max() stack, but only use the stack for the 
> different scopes as needed similar as when the calls weren't inlined. 
> But gcc 3 didn't do that.

That's roughly what I wanted to say.

> > With foo() and bar() inlined (-funit-at-a-time also enables 
> > -finline-functions-called-once), the maxmimum stack usage inside 
> > foobar() is sum(stack usage foo(), stack usage bar()). And this
> > worst case is the area where gcc 4 is much better than gcc 3.4.
> 
> Yes exactly.  If the functions weren't inlined the problem wouldn't
> occur because the stack sizes do not add up in the same dynamic call chain. 
> Thus a few statetic noinlines will fix it.

And we are back at my main point that risking regressions for getting 
better code with some ancient compiler isn't worth it.

Plus the fact that noinline's might result in slightly worse code with 
current compilers.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

