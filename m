Return-Path: <linux-kernel-owner+w=401wt.eu-S1763636AbZD3Ozu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763636AbZD3Ozu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762547AbZD3OzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:55:09 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:38012 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762740AbZD3OzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:55:06 -0400
Date: Thu, 30 Apr 2009 10:45:29 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090430143819.GF14696@elte.hu>
Message-ID: <alpine.DEB.1.10.0904301042170.4028@qirst.com>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <alpine.DEB.1.10.0904300921290.22262@qirst.com> <20090430133859.GB8329@elte.hu> <alpine.DEB.1.10.0904300938220.22262@qirst.com>
 <20090430141446.GD14696@elte.hu> <alpine.DEB.1.10.0904301013110.14178@qirst.com> <20090430143819.GF14696@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Ingo Molnar wrote:

> > Yes but sometimes you are already irq safe and such a fallback
> > would create significant irq/enable/disable stack operations etc
> > overhead for architectures that are using the fallback.
>
> It's a fallback slowpath - non-x86 architectures should still fill
> in a real implementation of course.

Arch code cannot provide an effective implementation since they
always have to assume that interupts need to be disabled if we stay with
the current implementation.

> So we first have to see the list of architectures that _cannot_
> implement an irq-safe op here via a single machine instruction.
> x86, ia64 and powerpc should be fine.

Look at Ia64, sparc, s/390, powerpc. They can fall back to atomic ops but
those are very ineffective on some of these platforms. Since these are
performance critical they will need to be optimized depending on the
context of their use in the core.




