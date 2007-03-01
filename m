Return-Path: <linux-kernel-owner+w=401wt.eu-S1030302AbXCAVhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030302AbXCAVhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 16:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030306AbXCAVhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 16:37:42 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50133 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030302AbXCAVhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 16:37:41 -0500
Date: Thu, 1 Mar 2007 22:30:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch - v3] epoll ready set loops diet ...
Message-ID: <20070301213004.GA15356@elte.hu>
References: <Pine.LNX.4.64.0702281034050.6806@alien.or.mcafeemobile.com> <200702282009.29527.dada1@cosmosbay.com> <Pine.LNX.4.64.0702281115090.6806@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702281115090.6806@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Davide Libenzi <davidel@xmailserver.org> wrote:

> > I was wrong about the size of epitem : it is now 68 bytes instead of 
> > 72. At least we now use/dirty one cache line instead of two per 
> > epitem.
> > 
> > Do you have another brilliant idea to shrink 4 more bytes ? :)
> 
> I don't think we can cleanly shove more stuff out of it.

then i'd suggest to not align events to 64 bytes, especially since the 
events are handled by the same CPU in one go. 68 bytes also 
automatically colors the fields in the L1 cache (it might matter).

	Ingo
