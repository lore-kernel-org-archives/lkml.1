Return-Path: <linux-kernel-owner+w=401wt.eu-S965199AbXCBTri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199AbXCBTri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 14:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965218AbXCBTri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 14:47:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45588 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965199AbXCBTrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 14:47:37 -0500
Date: Fri, 2 Mar 2007 20:39:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070302193941.GB8450@elte.hu>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu> <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru> <20070301150942.GA26025@elte.hu> <20070301153655.GB8217@2ka.mipt.ru> <20070302105713.GB15576@elte.hu> <Pine.LNX.4.64.0703020928580.1977@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703020928580.1977@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> [...] We're still missing proper FPU context switch in the 
> move_user_context(). [...]

yeah - i'm starting to be of the opinion that the FPU context should 
stay with the threadlet, exclusively. I.e. when calling a threadlet, the 
'outer loop' (the event loop) should not leak FPU context into the 
threadlet and then expect it to be replicated from whatever random point 
the threadlet ended up sleeping at. It would be possible, but it just 
makes no sense. What makes most sense is to just keep the FPU context 
with the threadlet, and to let the 'new head' use an initial (unused) 
FPU context. And it's in fact the threadlet that will most likely have 
an acrive FPU context across a system call, not the outer loop. In other 
words: no special FPU support needed at all for threadlets (i.e. no 
flipping needed even) - this behavior just naturally happens in the 
current implementation. Hm?

	Ingo
