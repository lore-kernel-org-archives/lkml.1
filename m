Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbYINOtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbYINOtY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbYINOtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:49:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59686 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672AbYINOtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:49:10 -0400
Date: Sun, 14 Sep 2008 16:48:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: acme@redhat.com, vegard.nossum@gmail.com, netdev@vger.kernel.org,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28] tcp_ipv6: fix use of uninitialized memory
Message-ID: <20080914144849.GI12522@elte.hu>
References: <20080912070525.GA22276@damson.getinternet.no> <20080912124405.GF8935@ghostprotocols.net> <20080912.161711.206773065.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080912.161711.206773065.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date: Fri, 12 Sep 2008 09:44:05 -0300
> 
> > Em Fri, Sep 12, 2008 at 09:05:25AM +0200, Vegard Nossum escreveu:
> > > >From 6544c4074aa5dde2e3f4d3e02f5601c1c33b770e Mon Sep 17 00:00:00 2001
> > > From: Vegard Nossum <vegard.nossum@gmail.com>
> > > Date: Tue, 9 Sep 2008 07:17:32 +0200
> > > Subject: [PATCH] tcp_ipv6: fix use of uninitialized memory
> > > 
> > > inet6_rsk() is called on a struct request_sock * before we
> > > have checked whether the socket is an ipv6 socket or a ipv6-
> > > mapped ipv4 socket. The access that triggers this is the
> > > inet_rsk(rsk)->inet6_rsk_offset dereference in inet6_rsk().
> > > 
> > > This is arguably not a critical error as the inet6_rsk_offset
> > > is only used to compute a pointer which is never really used
> > > (in the code path in question) anyway. But it might be a
> > > latent error, so let's fix it.
> > > 
> > > Spotted by kmemcheck.
> > 
> > Humm, so this was poisoned at allocation and then when inet6_rsk_offset
> > was accessed it noticed, interesting, thanks!
> > 
> > Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Good find :)  I'll add this to net-next-2.6, thanks!

nice - i think kmemcheck is starting to build up a healthy list of 
references :-)

	Ingo
