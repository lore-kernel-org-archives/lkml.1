Return-Path: <linux-kernel-owner+w=401wt.eu-S1757931AbXGCP67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931AbXGCP67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760810AbXGCP6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:58:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36626 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760689AbXGCP6q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:58:46 -0400
Date: Tue, 3 Jul 2007 08:58:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net, Jeff Dike <jdike@addtoit.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [uml-devel] [PATCH 4/5] UML - Simplify helper stack handling
Message-Id: <20070703085830.9b0520a1.akpm@linux-foundation.org>
In-Reply-To: <200707031728.36472.blaisorblade@yahoo.it>
References: <20070614202655.GA9647@c2.user-mode-linux.org>
	<20070627233701.8e53f3cb.akpm@linux-foundation.org>
	<200707031728.36472.blaisorblade@yahoo.it>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007 17:28:30 +0200 Blaisorblade <blaisorblade@yahoo.it> wrote:

> On giovedì 28 giugno 2007, Andrew Morton wrote:
> > So I'm running the generic version of this on i386 with 8k stacks (below),
> > with a quick LTP run.
> >
> > Holy cow, either we use a _lot_ of stack or these numbers are off:
> >
> > vmm:/home/akpm> dmesg -s 1000000|grep 'bytes left'
> > khelper used greatest stack depth: 7176 bytes left
> > khelper used greatest stack depth: 7064 bytes left
> > khelper used greatest stack depth: 6840 bytes left
> > khelper used greatest stack depth: 6812 bytes left
> > hostname used greatest stack depth: 6636 bytes left
> > uname used greatest stack depth: 6592 bytes left
> > uname used greatest stack depth: 6284 bytes left
> > hotplug used greatest stack depth: 5568 bytes left
> > rpc.nfsd used greatest stack depth: 5136 bytes left
> > chown02 used greatest stack depth: 4956 bytes left
> > fchown01 used greatest stack depth: 4892 bytes left
> 
> > That's the sum of process stack and interrupt stack, but I doubt if this
> > little box is using much interrupt stack space.
> >
> > No wonder people are still getting stack overflows with 4k stacks...
> 
> First, those numbers pretend to be _unused_ stack space.

Yep.  So fchown01 used ~3200 bytes of stack.  Problem.

> Well, UML tends to use more stack space than the rest of kernel.

That was a plain old i386 kernel.

