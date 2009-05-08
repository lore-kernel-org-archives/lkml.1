Return-Path: <linux-kernel-owner+w=401wt.eu-S1763236AbZEHPbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763236AbZEHPbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbZEHPbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:31:12 -0400
Received: from gw.goop.org ([64.81.55.164]:53952 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbZEHPbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:31:10 -0400
Message-ID: <4A04503E.3050807@goop.org>
Date: Fri, 08 May 2009 08:31:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <jbeulich@novell.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/5] xen/x86-64: clean up warnings	aboutIST-using
 traps
References: <4A032EE0.9030607@goop.org> <4A03F947.76EA.0078.0@novell.com> <20090508085805.GA28455@elte.hu>
In-Reply-To: <20090508085805.GA28455@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Yes. Also, patches 1-2-3 really just do the same thing, one fixes 
> the other one. Would be nice to have a single patch for that whole 
> ugly topic of 64-bit Xen not handling ISTs properly.
>   

Well, 1 is sufficient on its own to fix the breakpoint/watchpoint 
problem.  Looks like I need to do something similar with stack.  The 2,3 
are more general cleanups that aren't essential to the functional fix, 
and should definitely be folded together.

> If this was a CPU we'd say "sorry, dont run Linux on it then" ...
>   

??  Guests don't really need IST because all the tricky traps that 
really require it (NMI, MCE, etc) are handled by Xen.  The stack 
exception was an oversight on my part, because I thought it was 
something that would only happen with a bad kernel stack (but I guess 
that's doublefault).

> I've applied the reservation fix to x86/urgent, and the #5 patch to 
> x86/xen (it's more of a cleanup, not a fix for .30, right?).
>   

Right.

    J
