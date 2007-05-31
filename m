Return-Path: <linux-kernel-owner+w=401wt.eu-S1759062AbXEaTSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062AbXEaTSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbXEaTRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:17:54 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2352 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbXEaTRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:17:53 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 31 May 2007 12:17:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jakub Jelinek <jakub@redhat.com>
cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
In-Reply-To: <20070531190235.GY4033@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0705311205520.30485@alien.or.mcafeemobile.com>
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0705311123370.30485@alien.or.mcafeemobile.com>
 <465F170B.3070603@redhat.com> <Pine.LNX.4.64.0705311144290.30485@alien.or.mcafeemobile.com>
 <20070531190235.GY4033@devserv.devel.redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007, Jakub Jelinek wrote:

> On Thu, May 31, 2007 at 11:46:31AM -0700, Davide Libenzi wrote:
> > On Thu, 31 May 2007, Ulrich Drepper wrote:
> > > Davide Libenzi wrote:
> > > > Isn't this better be a global process flag? Default should be, for legacy
> > > > reasons,
> > > 
> > > No.  Policies are always wrong since it means code that cannot change
> > > the policy (e.g, all runtime libraries) have no access to the
> > > functionality.  I cannot set the policy to default to close-on-exit in
> > > glibc all the while the application assumes this is not the case.
> > 
> > I was talking for a broader usage, not only glibc centric. Most ppl 
> > writing MT+exec apps wants all but (eventually) and handfull of files 
> > leaking across the exec boundary.
> 
> If open (and all other syscalls that create fds) have O_CLOEXEC (and
> something similar for other syscalls), then such a policy can be easily
> implemented on the userland, if desired.

That, unless you change all the syscalls creating files to accept new 
parameters, would require a syscall+fcntl operation. That is not atomic 
(ie, another thread might do exec between the syscall and the fcntl). 
Again, mine was a general comment, not directed into magically fixing 
existing buggy code. What I meant, was that the vast majority of MT+exec 
apps wants all their fds (but an handfull, maybe) to be O_CLOEXEC. So a 
global, non-inheritable, per-process flag seemed the most straightforward 
solution.



- Davide


