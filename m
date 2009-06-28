Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbZF1XlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbZF1XlO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 19:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbZF1XlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 19:41:00 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:46549 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZF1Xk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 19:40:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19015.65376.650751.35877@cargo.ozlabs.ibm.com>
Date: Mon, 29 Jun 2009 09:40:16 +1000
From: Paul Mackerras <paulus@samba.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 0/2] perfcounter: callchains with perf report
In-Reply-To: <20090628210554.GA6267@nowhere>
References: <1246026481-8314-1-git-send-email-fweisbec@gmail.com>
	<19013.29199.123045.531291@cargo.ozlabs.ibm.com>
	<20090628210554.GA6267@nowhere>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker writes:

> On Sat, Jun 27, 2009 at 11:12:47AM +1000, Paul Mackerras wrote:
>
> > That means I need to make some changes to builtin-report.c to ignore
> > zero addresses.  I may need to add stuff to look for and use unwind
> > tables as well, if we want completely accurate call chains.
> 
> 
> Well, I guess I can ignore them in my further patches.
> But wouldn't it be better to discard them from the kernel?
> Unless it's somewhat useful to know we had an unknown entry?

If we discard the entries then userspace doesn't know which entries
were discarded, or whether any were discarded.  As it is, userspace
can know that the second value after PERF_CONTEXT_KERNEL/USER is a LR
value or zero, and the third value is from the second stack frame (or
zero).  If we discarded the entries then userspace wouldn't know
exactly where the second and third values came from, which would make
it harder to use unwind or traceback tables to work out more
accurately what the call chain was.

I would be open to replacing the bogus entries with some other
distinguishable value rather than zero if you think that would be
better.

Paul.
