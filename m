Return-Path: <linux-kernel-owner+w=401wt.eu-S1757287AbZAINrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbZAINrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 08:47:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbZAINrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 08:47:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37731 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbZAINri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 08:47:38 -0500
Date: Fri, 9 Jan 2009 14:47:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/9] Performance counters for POWER
Message-ID: <20090109134727.GA902@elte.hu>
References: <18791.10652.298501.863657@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18791.10652.298501.863657@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> The following series of patches extends Ingo and Thomas's performance 
> counter framework to add support for 64-bit POWER processors. Currently 
> I have the PPC970 family and POWER6 done.

Cool stuff!

> The approach I have taken is to do the constraint checking and the 
> search through the space of alternative event codes as each group of 
> counters is added at the time a task is scheduled in.  That means we are 
> potentially doing the search several times in a row, with interrupts 
> disabled.  I think it will be OK since there are only a few events that 
> have alternatives (and not many of them), and the constraint checking is 
> fast since it is just simple integer operations.  However, one of the 
> things I plan to do is to instrument that code to find out how long it 
> takes in the worst case.  (If it takes too long then I will need some 
> major changes to the generic code.)

Sounds like a very good approach to me. I think the core code wants to be 
optimistic towards the non-presence of scheduling constraints. So as 
hardware improves and evolves [which we all hope it does], so will 
hopefully the constraint related overhead become smaller.

> This series is also available via git at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git
> 
> in the master branch.

Great work Paul!

Do timec.c and kerneltop.c work fine for you by any chance? If yes, could 
you send us some sample output that you get with them on your power 
testbox(es)?

Also, would this be the right moment for me to pull from you?

Your modifications to kernel/perf_counter.c are all fixes and sensible 
extensions, and i expect the x86 side should continue to work just fine, 
so i'd like to pull this ASAP :-)

	Ingo
