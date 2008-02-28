Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbYB1B6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbYB1B6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 20:58:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbYB1B63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 20:58:29 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755612AbYB1B62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 20:58:28 -0500
Date: Wed, 27 Feb 2008 17:57:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: Linux 2.6.25-rc2
Message-Id: <20080227175726.ad6bda9d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802271532220.14380@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	<64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
	<20080219061107.GA23229@elte.hu>
	<64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
	<84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
	<20080219140230.GA32236@Krystal>
	<84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com>
	<20080219200852.GC11197@Krystal>
	<Pine.LNX.4.64.0802271532220.14380@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 15:32:52 -0800 (PST) Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 19 Feb 2008, Mathieu Desnoyers wrote:
> 
> > incrementing the variable with a "++" when interrupts are not disabled.
> > It's not an atomic add and it's racy. The code within stat() does
> > exactly this.
> 
> Yes but that is only for used for statistics which can be racy. Note that 
> the VM event statistics also can be racy.
> 

Doing ++ on a u32 _is_ atomic wrt interrupts on x86 and probably lots of
other architectures, so we're OK using unsigned there.  But on some other
architectures ++ on u32 is not atomic wrt interrutps, so they should use
atomic_t or some other arch-specific mechanism.

And guess what?  It's already all been done: local_t.
