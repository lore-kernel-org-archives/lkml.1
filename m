Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbZIOHsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbZIOHsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbZIOHse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:48:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43812 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbZIOHsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:48:33 -0400
Date: Tue, 15 Sep 2009 09:48:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [origin tree SLAB corruption #2] BUG kmalloc-64: Poison
	overwritten, INFO: Allocated in bdi_alloc_work+0x2b/0x100 age=175
	cpu=1 pid=3514
Message-ID: <20090915074802.GA21895@elte.hu>
References: <20090912072450.GA6767@elte.hu> <1252808939.13780.30.camel@dhcp231-106.rdu.redhat.com> <20090914071631.GA24801@elte.hu> <alpine.LFD.2.01.0909140725470.3654@localhost.localdomain> <20090914162902.GF6773@linux.vnet.ibm.com> <20090914171037.GG14984@kernel.dk> <20090915065707.GA3435@elte.hu> <20090915071158.GA31392@elte.hu> <20090915072433.GS14984@kernel.dk> <20090915074425.GA13689@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915074425.GA13689@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> > trying to pull in:
> > 
> >   git://git.kernel.dk/linux-2.6-block.git writeback
> > 
> > and see if it reproduces there? That path has been cleaned up 
> > considerably there.
> 
> I gave it a test-pull - and the bug does not trigger anymore.
> 
> Note, that may not mean much: your tree is based on a fresh upstream 
> tree so it pulled a lot of new stuff into -tip that i have yet to 
> test/validate. It also changed the kernel image size/layout 
> considerably and this bug seems to be a very narrow to hit race of 
> sorts.

Btw., is there anything in your cleanups that could explain this bug? 
Some list handling bug? A double free? Uninitialized memory? Race 
between block IRQs and process context?

	Ingo
