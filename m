Return-Path: <linux-kernel-owner+w=401wt.eu-S1763042AbYF0VZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763042AbYF0VZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbYF0VY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:24:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60381 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752AbYF0VY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:24:57 -0400
Date: Fri, 27 Jun 2008 23:25:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       hpa@zytor.com, yhlu.kernel@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal in some kernel info printks
Message-ID: <20080627212543.GA3880@uranus.ravnborg.org>
References: <20080624203252.f932c631.pj@sgi.com> <4861A5DF.5010104@zytor.com> <20080624211711.8c6d5105.pj@sgi.com> <4861AAEF.3020103@zytor.com> <alpine.LFD.1.10.0806241949030.13106@hp.linux-foundation.org> <20080624220810.b2ec0c6a.pj@sgi.com> <alpine.LFD.1.10.0806242101460.20369@hp.linux-foundation.org> <20080625145331.GA20941@elte.hu> <20080626191406.GC13699@uranus.ravnborg.org> <20080627120040.GA30872@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627120040.GA30872@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > For each Makefile (does not apply recursively):
> > ccflags-$(CONFIG_PROMOTE_WARNINGS_TO_ERROR) += -Werror
> > 
> > When I get around to it:
> > ccflags-sched.o-$(CONFIG_PROMOTE_WARNINGS_TO_ERROR) += -Werror
> 
> if there's a generic kbuild facility for it i'd love to try something 
> like that out, on files that i maintain. There should perhaps be a 
> shortcut for it? Something like:
> 
>   ccflags-sched.o += -Werror
> 
> and kbuild would decide whether CONFIG_PROMOTE_WARNINGS_TO_ERROR is set 
> and whether to filter out -Werror or not?

I would prefer to have a simpler CONFIG name and then
use the generic version.
So something like:

ccflags-sched.o-$(CONFIG_CC_Werror) += -Werror
It is in the above line obvious that we for sched.o add the -Werror
option if the CONFIG option CC_Werror is y.

	Sam
