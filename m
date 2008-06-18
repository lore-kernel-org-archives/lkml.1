Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYFRJ5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYFRJ5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 05:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYFRJ5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 05:57:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYFRJ5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 05:57:32 -0400
Date: Wed, 18 Jun 2008 11:57:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] modules: Take a shortcut for checking if an address is
	in a module
Message-ID: <20080618095711.GC15255@elte.hu>
References: <20080610130519.21bc66f3@infradead.org> <200806112112.08623.rusty@rustcorp.com.au> <20080611081847.0b22079c@infradead.org> <19f34abd0806111154q77739a2m8dcff24e2f9a3922@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806111154q77739a2m8dcff24e2f9a3922@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> >  > > Various pieces of the kernel (lockdep, latencytop, etc) tend to 
> >  > > store backtraces, sometimes at a relatively high frequency. In 
> >  > > itself this isn't a big performance deal (after all you're 
> >  > > using diagnostics features), but there have been some 
> >  > > complaints from people who have over 100 modules loaded that 
> >  > > this is a tad too slow.
> 
> Would it be overkill to simply drop the module addresses in an rbtree 
> and use that instead of a linear search over all the modules?
> 
> It would probably take a fair number of lines in C, and with a little 
> memory overhead, but the speed-up should be great. Should I give it a 
> try? (It would be arch-independent too.)

that's a tempting idea. rbtrees seem to be equally robust to plain lists 
in my experience, so i'd not find the extra complexity a showstopper, as 
long as the changes are well-tested. (radix trees on the other hand ... 
;-)

Rusty, Peter, Linus, any fundamental objections to Vegard's idea? Being 
able to take a transparent stack-trace signature for debugging or 
instrumentation purposes is important and performance does matter there 
IMO.

	Ingo
