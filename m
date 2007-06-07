Return-Path: <linux-kernel-owner+w=401wt.eu-S937539AbXFGWXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937539AbXFGWXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936935AbXFGWWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:22:51 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2445 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936903AbXFGWWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:22:50 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 Jun 2007 15:22:47 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706071521490.6445@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, Linus Torvalds wrote:

> It has the disadvantage that it would need some per-architecture setup to 
> load the actual real arguments from memory: the system call would probably 
> look something like
> 
> 	syscall_indirect(unsigned long flags, sigset_t *, 
> 			 int syscall, unsigned long args[6]);
> 
> and the rule would be that it would just load the six system call 
> registers from that "args[]" array. Always load the full six registers, to 
> make it simpler and faster, and not having any confusion or ever needing 
> any wrappers that depend on the number of system calls.

We'd still need sys_nonseqfd() though, to move/dup legacy fds into the 
non-sequential area.



- Davide


