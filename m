Return-Path: <linux-kernel-owner+w=401wt.eu-S935120AbXGQSTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935120AbXGQSTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759240AbXGQSTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:19:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36077 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758758AbXGQSTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:19:37 -0400
Date: Tue, 17 Jul 2007 20:18:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070717181857.GA16918@elte.hu>
References: <20070716091236.GA10718@elte.hu> <200707171607.08644.olaf.kirch@oracle.com> <20070717165720.GA4386@elte.hu> <200707172006.11664.olaf.kirch@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707172006.11664.olaf.kirch@oracle.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Olaf Kirch <olaf.kirch@oracle.com> wrote:

> Hi Ingo,
> 
> On Tuesday 17 July 2007 18:57, Ingo Molnar wrote:
> > i've done the patch below, but it did not change the timeouts nor did it 
> > solve the 'no network' problem. netconsole output hung earlier as well.
> Hm, pity.
> 
> To rule out any e1000 problem, can you try the the following please, 
> both with HZ=250 and HZ=1000?

done, find the logs here:

 http://redhat.com/~mingo/misc/100hz.log
 http://redhat.com/~mingo/misc/1000hz.log

(one is HZ=100, the other HZ=1000. HZ=100 produces a hung network just 
like HZ=250.)

no 'rx_sched set' messages in either case. Network still hung for 
HZ=100, and is working for HZ=1000.

	Ingo
