Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbYJJPQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbYJJPQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbYJJPQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:16:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757864AbYJJPQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:16:21 -0400
Date: Fri, 10 Oct 2008 08:15:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [git pull] x86 updates for v2.6.28, phase #1
In-Reply-To: <20081009234705.GA20540@elte.hu>
Message-ID: <alpine.LFD.2.00.0810100808540.3524@nehalem.linux-foundation.org>
References: <20081009234705.GA20540@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Oct 2008, Ingo Molnar wrote:
> 
> Vegard Nossum (3):
>       x86: consolidate header guards
>       x86: consolidate header guards

Ok, so I pulled phase 1, but quite frankly, I think this was utter crap. 
Why the hell did this go in?

The #1 "argument" for this was:

  1. No leading underscore. Names with leading underscores are reserved.

but what the _hell_ do you think kernel header files are? They are system 
header files, and they _should_ use the reserved name-space.

Quite frankly, it's entirely possible that some crazy - but perfectly 
correct - user space program does something like

	#include <sys/types.h>

	int ASM_X86__TYPES_H = 1;

and the whole point in using underscores in system header files is that 
those names are reserved TO THE SYSTEM, so that normal portable programs 
never need to worry about their choice of names.

You just broke this. For no good reason. Just to make things uglier, and 
just because people apparently don't understand _why_ leading underscores 
are special. They are special exactly _because_ they are reserved for 
system use, and there is little less "systemy" than the headers exported 
by the kernel.

And yes, yes, we could add the f*cking things back when we export them as 
header files, but what's the point, really? And no, I'm not guaranteeing 
that we're being super-careful about namespace issues in all kernel 
headers that can get exported to user space, but we _try_.

			Linus
