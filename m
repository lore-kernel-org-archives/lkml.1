Return-Path: <linux-kernel-owner+w=401wt.eu-S1030818AbXFHP7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030818AbXFHP7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967312AbXFHP7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:59:14 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:37368 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764103AbXFHP7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:59:13 -0400
Date: Fri, 8 Jun 2007 11:56:03 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070608155603.GA8058@c2.user-mode-linux.org>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606235906.72439d16@the-village.bc.nu> <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 01:10:23PM -0700, Linus Torvalds wrote:
> HOWEVER.
> 
> I think we could introduce a *single* new system call, which does 
> basically a "run the specified system call with the following flags".

As long as we are considering indirecting system calls, how about
reviving your proposal to run a system call in a different address
space:
	http://www.ussg.iu.edu/hypermail/linux/kernel/0212.3/0502.html

UML could make good use of the ability to remotely manipulate address
spaces.  I never liked any of the proposed interfaces very much,
including mm_indirect.  However, if my tastebuds are defective, and
indirecting system calls is the way to solve a family of problems,
then we should look at fitting in mm_indirect.

> It has the disadvantage that it would need some per-architecture setup to 
> load the actual real arguments from memory: the system call would probably 
> look something like
> 
> 	syscall_indirect(unsigned long flags, sigset_t *, 
> 			 int syscall, unsigned long args[6]);

mm_indirect would need a file descriptor to the other address space,
which we would presumably get from a new get_mm() system call.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
