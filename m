Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbYJAX7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbYJAX7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 19:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYJAX71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 19:59:27 -0400
Received: from www.tglx.de ([62.245.132.106]:34507 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbYJAX70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 19:59:26 -0400
Date: Thu, 2 Oct 2008 01:58:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu, benh@kernel.crashing.org,
       rostedt@goodmis.org, jonathan@jonmasters.org, sdietrich@suse.de
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded interrupt
 handlers
In-Reply-To: <20081001164013.f72036c9.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0810020154570.5549@apollo.tec.linutronix.de>
References: <20081001223213.078984344@linutronix.de> <20081001162333.e1509240.akpm@linux-foundation.org> <20081001162950.61887d08@infradead.org> <20081001164013.f72036c9.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008, Andrew Morton wrote:

> On Wed, 1 Oct 2008 16:29:50 -0700
> Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Wed, 1 Oct 2008 16:23:33 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > 
> > > I'm a bit surprised to see that there is no facility for per-cpu
> > > interrupt threads?
> > > 
> > 
> > per handler is the right approach (that way, if one dies, all other
> > interrupts will likely keep working)
> > 
> > now.. normally an interrupt only goes to one cpu, so effectively it is
> > per cpu already anyway
> 
> Yes, if a) the thread was asleep when it was woken up and b) if the
> scheduler does the right thing and wakes the thread on the CPU which
> called wake_up().
> 
> The ongoing sagas of tbench/mysql/volanomark regressions make me think
> that any behaviour which we "expect" of the scheduler should be
> triple-checked daily :(

Yup. I missed that detail when I dusted off the moldy patches. 

Of course we need to pin the thread to the affinity mask of the
hardware interrupt.

/me goes back to do home work :)

Thanks,

	tglx
