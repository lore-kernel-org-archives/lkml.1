Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbXI3PyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbXI3PyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758307AbXI3Pxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:53:49 -0400
Received: from www.tglx.de ([62.245.132.106]:37721 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757994AbXI3Pxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:53:48 -0400
Date: Sun, 30 Sep 2007 17:53:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] robust futex thread exit race
In-Reply-To: <20070930151827.GB23127@elte.hu>
Message-ID: <alpine.LFD.0.9999.0709301750430.3142@localhost.localdomain>
References: <1191164539.4047.5.camel@localhost> <20070930151827.GB23127@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 30 Sep 2007, Ingo Molnar wrote:
> * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > Hi Ingo,
> > I finally found the bug that causes tst-robust8 from the glibc to fail
> > on s390x. Turned out to be a common code problem with the processing of
> > the robust futex list. The patch below fixes the bug for me.
> 
> good catch! A quick preliminary review of your patch indicates it's fine 
> - and it might be v2.6.23 material.
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

  Acked-by: Thomas Gleixner <tglx@linutronix.de>
 
> > Calling handle_futex_death in exit_robust_list for the different 
> > robust mutexes of a thread basically frees the mutex. Another thread 
> > might grab the lock immediately which updates the next pointer of the 
> > mutex. fetch_robust_entry over the next pointer might therefore branch 
> > into the robust mutex list of a different thread. This can cause two 
> > problems: 1) some mutexes held by the dead thread are not getting 
> > freed and 2) some mutexs held by a different thread are freed. The 
> > next point need to be read before calling handle_futex_death.
> 
> nasty race... Ulrich, Thomas, do you concur?

Yes. Where do they sell those brown paperbags again ?

	tglx

