Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbXBNVgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbXBNVgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932649AbXBNVgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:36:17 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3821 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648AbXBNVgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:36:16 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Feb 2007 13:36:13 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
 call support
In-Reply-To: <45D3768B.7010902@goop.org>
Message-ID: <Pine.LNX.4.64.0702141321410.7796@alien.or.mcafeemobile.com>
References: <20070213142010.GA638@elte.hu> <45D3768B.7010902@goop.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Jeremy Fitzhardinge wrote:

> Are there any special semantics that result from running the syslet
> atoms in kernel mode?  If I wanted to, could I write a syslet emulation
> in userspace that's functionally identical to a kernel-based
> implementation?  (Obviously the performance characteristics will be
> different.)
> 
> I'm asking from the perspective of trying to work out the Valgrind
> binding for this if it goes into the kernel.  Valgrind needs to see all
> the input and output values of each system call the client makes,
> including those done within the syslet mechanism.  It seems to me that
> the easiest way to do this would be to intercept the syslet system
> calls, and just implement them in usermode, performing the same series
> of syscalls directly, and applying the Valgrind machinery to each one in
> turn.
> 
> Would this work?

Hopefully the API will simplify enough so that emulation will becomes 
easier.



> Also, an unrelated question: is there enough control structure in place
> to allow multiple syslet streams to synchronize with each other with
> futexes?

I think the whole point of an async execution of a syscall or a syslet, is 
that the syscall/syslet itself includes a non interlocked operations with 
other syscalls/syslets. So that the main scheduler thread can run in a 
lockless/singletask fashion. There are no technical obstacles that 
prevents you to do it, bu if you start adding locks (and hence having 
long-living syslet-threads) at that point you'll end up with a fully 
multithreaded solution.



- Davide


