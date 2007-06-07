Return-Path: <linux-kernel-owner+w=401wt.eu-S936935AbXFGVmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936935AbXFGVmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765902AbXFGVly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:41:54 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:4796 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765239AbXFGVly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:41:54 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 14:41:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Eric Dumazet <dada1@cosmosbay.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <alpine.LFD.0.98.0706071356270.4205@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706071440040.6445@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
 <46686EFA.1030302@cosmosbay.com> <alpine.LFD.0.98.0706071356270.4205@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Linus Torvalds wrote:

> On Thu, 7 Jun 2007, Eric Dumazet wrote:
> > 
> > This is a nice idea, but 32/64 compat code is going to hate it :)
> 
> It should be fairly simple for 32/64-bit compat code too.
> 
> The compat code should just call the compat system call 
> 
> > syscall_indirect() would be writen in assembly for each arch, since there is
> > no generic syscall table. Thats really a lot of work, especially if we want to
> > mess with signal mask, umask ...
> 
> No no no. That would be horribly idiotic.
> 
> The thing should be 99% generic code, ie we would have
> 
> 	syscall_indirect(..)
> 	{
> 		long retval;
> 
> 		.. set up signals/flags ..
> 		retval = arch_syscall_indirect(syscall, args);
> 		.. unsetup signals/flags ..
> 		return retval;
> 	}
> 
> 	compat_syscall_indirect(..)
> 	{
> 		int retval;
> 
> 		.. set up signals/flags ..
> 		retval = compat_arch_syscall_indirect(syscall, args);
> 		.. unsetup signals/flags ..
> 		return retval;
> 	}
> 
> and the *only* thing that each architecture would need to do is that 
> (trivial) arch_syscall_indirect() thing (and the compat version, if 
> applicable). And those literally should be generally pretty damn trivial.

Ok, I like this better honestly. I really did not want to win the Oscar 
for the 2007 Syscall Spammer of the year :)



- Davide


