Return-Path: <linux-kernel-owner+w=401wt.eu-S936335AbXFGD3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936335AbXFGD3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 23:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbXFGD3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 23:29:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:42485 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbXFGD3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 23:29:36 -0400
Subject: Re: signalfd API issues (was Re: [PATCH/RFC] signal races/bugs,
	losing TIF_SIGPENDING and other woes)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: Paul Mackerras <paulus@samba.org>, Nicholas Miell <nmiell@comcast.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070607022002.GA11977@c2.user-mode-linux.org>
References: <1181023787.2785.14.camel@entropy>
	 <1181028453.31677.127.camel@localhost.localdomain>
	 <1181087462.2788.8.camel@entropy>
	 <Pine.LNX.4.64.0706051710140.23673@alien.or.mcafeemobile.com>
	 <1181088936.2788.10.camel@entropy>
	 <Pine.LNX.4.64.0706051736120.23673@alien.or.mcafeemobile.com>
	 <1181091523.2788.28.camel@entropy>
	 <1181098204.31677.158.camel@localhost.localdomain>
	 <20070606125259.GA5491@c2.user-mode-linux.org>
	 <18023.14494.889739.567439@cargo.ozlabs.ibm.com>
	 <20070607022002.GA11977@c2.user-mode-linux.org>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 13:29:23 +1000
Message-Id: <1181186963.14818.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 22:20 -0400, Jeff Dike wrote:
> On Thu, Jun 07, 2007 at 08:43:42AM +1000, Paul Mackerras wrote:
> > What Ben was talking about was stealing a synchronous SEGV from a task
> > without stopping it, and as Ben says that makes no sense.
> > Intercepting a signal and stopping the task is reasonable, and that is
> > what ptrace does, and I assume also UML.
> 
> It is, but I can also see UML stealing the SEGV from the child.  The
> UML skas does this - a ptrace extension, PTRACE_FAULTINFO, is used to
> extract page fault information from the child, and other pieces of the
> patch are used to fix the fault without the child continuing until
> it's fixed.  So, in this case, the child never sees the SEGV.

But you use ptrace and don't steal signals with dequeue_signal() on a
live other task, which is ok.

Ben.


