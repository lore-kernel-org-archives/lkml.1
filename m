Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYGWI2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYGWI2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 04:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbYGWI1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 04:27:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41229 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbYGWI1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 04:27:42 -0400
Date: Wed, 23 Jul 2008 10:26:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: David Newall <davidn@davidnewall.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [TCP bug] stuck distcc connections in latest -git
Message-ID: <20080723082643.GA992@elte.hu>
References: <20080721134506.GA27598@elte.hu> <20080721182318.GA20940@elte.hu> <alpine.LFD.1.10.0807211131390.31863@woody.linux-foundation.org> <20080721184616.GA8442@elte.hu> <20080722112133.GA6575@elte.hu> <4885E482.5020502@davidnewall.com> <20080722135723.GA23077@elte.hu> <4885F496.3010305@davidnewall.com> <20080722153443.GB18757@elte.hu> <20080722211256.GB29189@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722211256.GB29189@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> On Tue, Jul 22, 2008 at 05:34:43PM +0200, Ingo Molnar wrote:
> > * David Newall <davidn@davidnewall.com> wrote:
> > 
> > > Ingo Molnar wrote:
> > > > * David Newall <davidn@davidnewall.com> wrote:
> > > >   
> > > >> You really should start that capture, and on both client and server. 
> > > >> You don't need to dump everything, only traffic to or from 
> > > >> server:distcc.
> > > >>     
> > > >
> > > > It's not feasible. That box did in excess of 200 GB of network traffic 
> > > > in the past 7 hours alone.
> > > 
> > > You only need distcc traffic, and perhaps only after it's hung.  With 
> > > 250k outstanding per socket, are you certain that no traffic was sent? 
> > > Is it certain that one packet wasn't being sent each three minutes?  I 
> > > suppose you're right and the stack really is stuck, but this is such 
> > > an easy thing to check and eliminate that you should do so.  I 
> > > suppose, too, that you should trace the server-side processes and 
> > > confirm that they are waiting for socket input.  You should dump tcp 
> > > (for the distcc port) next time the problem recurs and also check that 
> > > the server processes are waiting for socket input.
> > 
> > ok, will do that if it happens again.
> 
> Ingo,
> 
> if it can help, I have a "capture" script which allows you to define a 
> size and will rotate captures within that size. That's what I'm using 
> to troubleshoot rarely occuring problems in datacenters, so it's 
> horrible but efficient :-)
> 
> You just have to stop it once the problem has happened again. Ping me 
> if you're interested (I'm lazy to start my laptop right just for it 
> now in fact).

yeah, that would be handy, thanks.

Alas, the problem has not reoccured since then - more than a thousand 
kernel builds down the line. Yesterday it triggered so quickly when i 
updated the buildbox to the new kernel, and happened repeatedly when i 
tried to build a new kernel, that i didnt assume it was something hard 
to reproduce - but it went poof after i restarted distccd on the server.

So i'd suggest we do not count this as a regression, i've got no way at 
the moment of reproducing it reliably.

	Ingo
