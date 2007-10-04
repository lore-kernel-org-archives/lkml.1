Return-Path: <linux-kernel-owner+w=401wt.eu-S1759437AbXJDRdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437AbXJDRdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbXJDRd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:33:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40243 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755605AbXJDRd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:33:28 -0400
Date: Thu, 4 Oct 2007 10:27:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Chouquet-Stringer <mchouque@free.fr>
cc: Ollie Wild <aaw@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
In-Reply-To: <m3wsu2u7y6.fsf@bigip.mine.nu>
Message-ID: <alpine.LFD.0.999.0710041023480.23684@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
 <m3wsu2u7y6.fsf@bigip.mine.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Oct 2007, Mathieu Chouquet-Stringer wrote:
> 
> I've seen the changes you made in commit b6a2fea39318 and I guess they
> might be responsible for my xargs breakage...
> 
> In the kernel source tree, if I run a stupid find | xargs ls, I now get
> this:
> xargs: ls: Argument list too long

What does your "ulimit -s" say?

I suspect that you might hit the code that limits execve() arguments to 
one quarter of the maximum stack size.

We could change that from 25% to something else (half? three quarters?), 
but if you really are hitting that limit, it sounds like you may have a 
really small stack size to begin with (ie if 25% is smaller than the old 
argument size limit of 128kB, you're running with a stack limit of less 
than half a meg, which sounds pretty dang small).

So I'd like to verify that the stack limit really is the issue, and not 
something else.

		Linus
