Return-Path: <linux-kernel-owner+w=401wt.eu-S1751337AbXFCUTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbXFCUTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXFCUTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:19:43 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1071 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXFCUTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:19:42 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 3 Jun 2007 13:19:39 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] ufd v1 - use unsequential O(1) fdmap
In-Reply-To: <466319DB.80800@redhat.com>
Message-ID: <Pine.LNX.4.64.0706031311490.13247@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825146.2>
 <4663067C.9050002@redhat.com> <Pine.LNX.4.64.0706031127220.13247@alien.or.mcafeemobile.com>
 <466319DB.80800@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007, Ulrich Drepper wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Davide Libenzi wrote:
> >> I agree with Ingo, no need for a second magic value.  Use the same value
> >>  as FD_UNSEQ_ALLOC which will just mean this exact value should never be
> >> used as a file descriptor.
> > 
> > I explained this in my answer to Ingo...
> 
> And if we have a new syscall we don't need any of that special dup2
> behavior you describe.  I really don't think this should be added.  dup2
> should just do what POSIX specifies, nothing more.  I would even suggest
> to not allow to dup2() to a descriptor > RLIMIT_NOFILE unless it is
> already allocated.  I.e., don't allow creating arbitrary high descriptors.
> 
> This behavior is completely consistent with the current implementation.
>  No bad surprises.  In fact, it eliminates parts of the ABI
> incompatibility I talked about.

Agreed, a new syscall looks less messy. I'll make sys_dup2() to allow 
installing in the non-sequential area, only if there's an fd already 
allocated. F_DUPFD will remain unchanged (that is, not allow 
non-sequential fds allocations).



> > Random can be expensive. At the moment is FIFO. I'm missing though how 
> > this can be a security flaw, when the legacy one is exactly predictable.
> 
> It's not an added security issue.  It would mean removing a possible
> security the current file descriptor allocation has.
> 
> If randomizing each allocator is too expensive then randomize at the
> very least the number of the first descriptor you give out.

Can you tell me how this can be a problem, and in which way making a 
random thing would help?



- Davide

