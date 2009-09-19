Return-Path: <linux-kernel-owner+w=401wt.eu-S1751336AbZISRkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbZISRkA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 13:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbZISRj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 13:39:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53679 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751177AbZISRj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 13:39:59 -0400
Date: Sat, 19 Sep 2009 19:39:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Korty <joe.korty@ccur.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Steve French <sfrench@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: circular locking dependency detected panic in filldir when
	CONFIG_PROVE_LOCKING=y
Message-ID: <20090919173948.GE5366@elte.hu>
References: <20090918211550.GA8258@tsunami.ccur.com> <1253309941.3183.104.camel@heimdal.trondhjem.org> <20090919072349.GC15292@elte.hu> <1253359188.7085.0.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253359188.7085.0.camel@laptop>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Sat, 2009-09-19 at 09:23 +0200, Ingo Molnar wrote:
> > * Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > 
> > > On Fri, 2009-09-18 at 17:15 -0400, Joe Korty wrote:
> > > > I experienced a might_fault panic from NFS's use of filldir
> > > > in a 2.6.31 kernel compiled with CONFIG_PROVE_LOCKING=y.
> > > > 
> > > > Looking at filldir, I see it is accessing user space with
> > > > __put_dir's (which are inatomic) and with one copy_to_user
> > > > (which is not inatomic).  It is the single copy_to_user
> > > > which is causing the might_fault panic.
> > > > 
> > > > It doesn't make any sense to be mixing use of inatomic
> > > > and non-inatomic services in filldir.  Either all should be
> > > > the inatomic version, or none should be.
> > > > 
> > > > The might_fault condition being reported by the panic looks
> > > > real to me, so I suspect the wrong answer is converting
> > > > everything to the inatomic version, since that just
> > > > suppresses the circular dependency check while leaving
> > > > the circular dependency in place.
> > > 
> > > Yes. This is known... Please see 
> > >    http://thread.gmane.org/gmane.linux.nfs/28578
> > > and
> > >    http://thread.gmane.org/gmane.linux.nfs/27406
> > > 
> > > I'm still hoping the VM folks can see fit to merge Peter's fix at some
> > > point...
> > 
> > Ouch, those patches at:
> > 
> >   http://programming.kicks-ass.net/kernel-patches/mmap-vs-nfs/
> > 
> > .... are 2 years old. Higher intensity prodding needed to get this 
> > moving?
> 
> No I just need to find a way to clone() myself :-)

I did not mean to prod you :-)

	Ingo
