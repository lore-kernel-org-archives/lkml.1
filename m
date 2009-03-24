Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbZCXPru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbZCXPru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbZCXPri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:47:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbZCXPrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:47:37 -0400
Date: Tue, 24 Mar 2009 16:47:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frank Blaschka <blaschka@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kernel@pengutronix.de
Subject: Re: Revert "gro: Fix legacy path napi_complete crash", (was: Re:
	Linux 2.6.29)
Message-ID: <20090324154717.GA7506@elte.hu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <20090324130202.GA32469@elte.hu> <20090324143303.GP5367@pengutronix.de> <20090324143942.GA20462@elte.hu> <20090324150928.GB30224@gondor.apana.org.au> <20090324153616.GA31143@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324153616.GA31143@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Herbert Xu <herbert@gondor.apana.org.au> wrote:
> 
> > On Tue, Mar 24, 2009 at 03:39:42PM +0100, Ingo Molnar wrote:
> > >
> > > Subject: [PATCH] net: Fix netpoll lockup in legacy receive path
> > 
> > Actually, this patch is still racy.  If some interrupt comes in
> > and we suddenly get the maximum amount of backlog we can still
> > hang when we call __napi_complete incorrectly.  It's unlikely
> > but we certainly shouldn't allow that.  Here's a better version.
> > 
> > net: Fix netpoll lockup in legacy receive path
> 
> ok - i'm testing with this now.

test failure on one of the boxes, interface got stuck after ~100K 
packets:

eth1      Link encap:Ethernet  HWaddr 00:13:D4:DC:41:12  
          inet addr:10.0.1.13  Bcast:10.0.1.255  Mask:255.255.255.0
          inet6 addr: fe80::213:d4ff:fedc:4112/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:22555 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1897 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:2435071 (2.3 MiB)  TX bytes:503790 (491.9 KiB)
          Interrupt:11 Base address:0x4000 

i'm going back to your previous version for now - it might still be 
racy but it worked well for about 1.5 hours of test-time.

	Ingo
