Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbZD3QSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbZD3QSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbZD3QSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:18:40 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:32850 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZD3QSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:18:39 -0400
Date: Thu, 30 Apr 2009 12:08:51 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <dada1@cosmosbay.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
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
In-Reply-To: <20090430160054.GB4723@elte.hu>
Message-ID: <alpine.DEB.1.10.0904301204490.4028@qirst.com>
References: <20090430024303.GB19875@Krystal> <alpine.DEB.1.10.0904300921290.22262@qirst.com> <20090430133859.GB8329@elte.hu> <alpine.DEB.1.10.0904300938220.22262@qirst.com> <20090430141446.GD14696@elte.hu> <alpine.DEB.1.10.0904301013110.14178@qirst.com>
 <20090430143819.GF14696@elte.hu> <alpine.DEB.1.10.0904301042170.4028@qirst.com> <20090430150142.GC20580@elte.hu> <alpine.DEB.1.10.0904301114440.4028@qirst.com> <20090430160054.GB4723@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Ingo Molnar wrote:

> The new percpu APIs could be used in most of these places already,
> straight away. This is a really good TODO list for places to
> enhance.

Please look a the full list in the cpu alloc v3 patchset and not only
those that I listed here.

> Then a second set of patches could convert percpu_add() / etc. uses
> to __percpu_add() ... but that should be done by those architectures
> that need it (and to the extent they need it), because it's not
> really testable on x86.

Ok So we convert it and wait until the arch maintainers complain? I
definitely know that there is an IA64 issue with vm statistics.

> I dont really like the PER_CPU / CPU_INC etc. type of all-capitals
> APIs you introduced in the patches above:

I know. Patches would have to be redone against whatever API we agree on.

>
> +		__CPU_INC(bt->sequence);
> +	CPU_FREE(bt->sequence);
>
> was there any strong reason to go outside the well-established
> percpu_* name space and call these primitives as if they were
> macros?

They are macros and may do weird things with the variables. This goes back
to our disagreement last year on caps/lower case. I still think this kind
of preprocessor magic should be uppercase.

The reason not to use the percpu_* names was that they were x86 arch
specific (and thus not available) and did not differentiate in terms of
the irq/preemption context.


