Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbXL2MyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbXL2MyY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 07:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbXL2MyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 07:54:15 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:54188 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbXL2MyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 07:54:14 -0500
Date: Sat, 29 Dec 2007 14:54:13 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Message-ID: <20071229125412.GE27360@does.not.exist>
References: <20071228212341.GA6939@uranus.ravnborg.org> <20071229093904.GA17390@uranus.ravnborg.org> <20071229095253.GC27360@does.not.exist> <200712291316.07938.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200712291316.07938.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 01:16:07PM +0100, Andi Kleen wrote:
> 
> If -funit-at-a-time really increases stack size too much on some compiler
> version the right fix would be to check where it does that using make checkstack
> and then add "noinline" attributes there to prevent the compiler from inlining.
> That would prevent them.
> 
> Globally disabling it is too big a hammer.
> 
> e.g. I know XFS did it in a similar way to prevent this problem.
> 
> So I would reenable it for now and if you know it causes problems on specific
> compiler versions, Adrian, you could watch make checkstack there and submit
> noinline patches as needed.

The main point is that we are _only_ talking about gcc 3.4 on i386 - for 
more recent compilers we do not disable unit-at-a-time.

First of all our user - and therefore tester - base with this compiler 
has become quite small. And checkstack alone doesn't help that much with 
finding the problems since it only lists per-function stack usage, not 
the stack usage of the complete call chain.

People who want maximum performance and/or minimum code size anyway 
won't use a more than 3 years old compiler.

If we were talking about gcc 4.2 I would agree with you, but I simply do 
not see the point in risking regressions for gcc 3.4 users when the only 
benefit would be better code with an ancient compiler.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

