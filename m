Return-Path: <linux-kernel-owner+w=401wt.eu-S964862AbXCOAPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbXCOAPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 20:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964868AbXCOAPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 20:15:50 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42499 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964862AbXCOAPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 20:15:48 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Mar 2007 17:10:50 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Benjamin LaHaise <bcrl@kvack.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 13/13] signalfd/timerfd/asyncfd v5 - KAIO asyncfd support
 (example/maybe-broken) ...
In-Reply-To: <20070315000212.GD1246@kvack.org>
Message-ID: <Pine.LNX.4.64.0703141702540.4982@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.13805.1173910770.13>
 <20070314231920.GB1246@kvack.org> <Pine.LNX.4.64.0703141620340.4982@alien.or.mcafeemobile.com>
 <20070314234208.GC1246@kvack.org> <Pine.LNX.4.64.0703141638570.4982@alien.or.mcafeemobile.com>
 <20070315000212.GD1246@kvack.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Benjamin LaHaise wrote:

> On Wed, Mar 14, 2007 at 04:41:58PM -0700, Davide Libenzi wrote:
> > Yeah, of course. I do not plan revolutions. Just asking if it's a possible 
> > thing to do. I can mlock the userspace ring, if imposing that burden over 
> > aio_complete() is seen as too heavy.
> 
> I'm not sure I follow what you're doing -- why isn't asyncfd merely calling 
> io_getevents() instead of reinventing everything the ringbuffer does?  The 
> aio ringbuffer is already locked in memory.  Fwiw, the aio ringbuffer was 
> originally wired up to a file descriptor, but that gave way to the actual 
> syscall in order to enforce proper typechecking and typical usage scenarios 
> with timeouts.

The purpose of asyncfd is to provide a pollable (by the mean of 
f_op->poll) device that can be hosted inside a standard select/poll/epoll 
wait subsystem, and that, at the same time, provide a zero-copy way for 
kernel code (KAIO and syslets/threadlets were my thought) to deliver 
results to userspace.



> Also, there have been patches floating around for aio_poll and a way to get 
> epoll wakeups into the aio event queue.  They deserve serious consideration 
> if this asyncfd seems necessary.

I don't want to talk about the AIO poll code, because last time I saw it, 
it did not look shiny.
But I think we can agree that ppl needs to have a way to wait for both 
block I/O (covered by either KAIO or syslets/threadlets) and all the other 
world (covered by epoll). This has been pretty clear for me, looking at 
the continuous request I got to provide block I/O completions through 
epoll, and looking at the hackage that ppl has currently to do in 
userspace to achieve that.
Now that I'm seeing I can wait for both block and net I/O, I got excited ;)



- Davide


