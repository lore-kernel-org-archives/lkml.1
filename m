Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZELN2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZELN2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZELN15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:27:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63451 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZELN14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:27:56 -0400
Date: Tue, 12 May 2009 09:27:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] [GIT PULL] ring-buffer: optimize to 17% performance
 increase
In-Reply-To: <20090512083301.GA20435@elte.hu>
Message-ID: <alpine.DEB.2.00.0905120923250.13234@gandalf.stny.rr.com>
References: <20090512040832.681953177@goodmis.org> <20090512083301.GA20435@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 12 May 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Before the patch series:
> > 
> > benchmark:  307 ns (220 ns)
> >    text    data     bss     dec     hex filename
> >   16554      24      12   16590    40ce kernel/trace/ring_buffer.o
> >           
> >          
> > commit 1cd8d7358948909ab80b254eb14bcebc555ad417
> > ring-buffer: remove type parameter from rb_reserve_next_event
> >              
> > benchmark: 302 ns (215 ns)
> >    text    data     bss     dec     hex filename
> >   16538      24      12   16574    40be kernel/trace/ring_buffer.o
> >     
> > commit be957c447f7233a67904a1b11eb3ab61e702bf4d
> > ring-buffer: move calculation of event length
> > 
> > benchmark: 293 ns (206 ns)
> >    text    data     bss     dec     hex filename
> >   16490      24      12   16526    408e kernel/trace/ring_buffer.o
> >     
> > commit 0f0c85fc80adbbd2265d89867d743f929d516805
> > ring-buffer: small optimizations
> > 
> > benchmark: 285 ns (198 ns)
> >    text    data     bss     dec     hex filename
> >   16474      24      12   16510    407e kernel/trace/ring_buffer.o
> > 
> > commit 88eb0125362f2ab272cbaf84252cf101ddc2dec9
> > ring-buffer: use internal time stamp function
> > 
> > benchmark: 282 ns (195 ns)
> >    text    data     bss     dec     hex filename
> >   16474      24      12   16510    407e kernel/trace/ring_buffer.o
> > 
> > 
> > commit 168b6b1d0594c7866caa73b12f3b8d91075695f2
> > ring-buffer: move code around to remove some branches
> > 
> > benchmark: 270 ns (183 ns)
> >    text    data     bss     dec     hex filename
> >   16490      24      12   16526    408e kernel/trace/ring_buffer.o
> > 
> > Thus we went from an average of 220 ns per recording, to 183 ns.
> > Which is about a 17% performance gain.
> 
> Nice!
> 
> It's also interesting to see that text size went down when speed 
> went up. I'm wondering how these compiler options:

But that was not always the case. The biggest boost in performance of the 
series (the last patch) also increased the size.

> 
>   CONFIG_CC_OPTIMIZE_FOR_SIZE=y
>   CONFIG_OPTIMIZE_INLINING=y

Note, my test runs had both the above configure options disabled.
I'll run it again and see how they affect the results:

-- Steve

