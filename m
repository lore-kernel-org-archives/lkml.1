Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbZISLUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbZISLUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 07:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbZISLUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 07:20:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:38748 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZISLUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 07:20:05 -0400
Subject: Re: circular locking dependency detected panic in filldir when
 CONFIG_PROVE_LOCKING=y
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Korty <joe.korty@ccur.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Steve French <sfrench@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090919072349.GC15292@elte.hu>
References: <20090918211550.GA8258@tsunami.ccur.com>
	 <1253309941.3183.104.camel@heimdal.trondhjem.org>
	 <20090919072349.GC15292@elte.hu>
Content-Type: text/plain
Date: Sat, 19 Sep 2009 13:19:48 +0200
Message-Id: <1253359188.7085.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 09:23 +0200, Ingo Molnar wrote:
> * Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > On Fri, 2009-09-18 at 17:15 -0400, Joe Korty wrote:
> > > I experienced a might_fault panic from NFS's use of filldir
> > > in a 2.6.31 kernel compiled with CONFIG_PROVE_LOCKING=y.
> > > 
> > > Looking at filldir, I see it is accessing user space with
> > > __put_dir's (which are inatomic) and with one copy_to_user
> > > (which is not inatomic).  It is the single copy_to_user
> > > which is causing the might_fault panic.
> > > 
> > > It doesn't make any sense to be mixing use of inatomic
> > > and non-inatomic services in filldir.  Either all should be
> > > the inatomic version, or none should be.
> > > 
> > > The might_fault condition being reported by the panic looks
> > > real to me, so I suspect the wrong answer is converting
> > > everything to the inatomic version, since that just
> > > suppresses the circular dependency check while leaving
> > > the circular dependency in place.
> > 
> > Yes. This is known... Please see 
> >    http://thread.gmane.org/gmane.linux.nfs/28578
> > and
> >    http://thread.gmane.org/gmane.linux.nfs/27406
> > 
> > I'm still hoping the VM folks can see fit to merge Peter's fix at some
> > point...
> 
> Ouch, those patches at:
> 
>   http://programming.kicks-ass.net/kernel-patches/mmap-vs-nfs/
> 
> .... are 2 years old. Higher intensity prodding needed to get this 
> moving?

No I just need to find a way to clone() myself :-)

