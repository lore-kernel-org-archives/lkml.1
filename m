Return-Path: <linux-kernel-owner+w=401wt.eu-S933962AbXC2BaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962AbXC2BaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 21:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934301AbXC2BaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 21:30:16 -0400
Received: from kanga.kvack.org ([66.96.29.28]:60348 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933962AbXC2BaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 21:30:14 -0400
Date: Wed, 28 Mar 2007 21:29:55 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Inlining can be _very_bad...
Message-ID: <20070329012955.GD17334@kvack.org>
References: <20070329011838.6e832615@werewolf-wl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070329011838.6e832615@werewolf-wl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 01:18:38AM +0200, J.A. Magallón wrote:
> It looks like is updating the stack on each iteration...This is -march=opteron
> code, the -march=pentium4 is similar. Same behaviour with gcc3 and gcc4.
> 
> tst.c and Makefile attached.
> 
> Nice, isn't it ? Please, probe where is my fault...

Yes, gcc sucks in its handling of large return values, news at 11.  I have 
several outstanding bugs on cases where gcc could keep things in registers 
but doesn't.

That said, it tends to do much better on plain integer code, as that is 
what it gets tuned for.  Do NOT propagate the blanket myth that inlining is 
a bad thing.  It is very useful for small functions where the overhead 
associated with call/ret sequences and register clobbers overshadows the 
work being done.  The call/ret updates alone can make a big difference when 
there are lots of other (more useful) memory transactions to complete.  Take 
a look at things like the notifier hooks for an example of something that 
does far too little work per function call and should really be inlined.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
