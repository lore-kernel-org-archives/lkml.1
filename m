Return-Path: <linux-kernel-owner+w=401wt.eu-S1762190AbYF3Sel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190AbYF3Sel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYF3Seb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:34:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58579 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbYF3Seb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:34:31 -0400
Date: Mon, 30 Jun 2008 20:33:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       mingo <mingo@redhat.com>, tglx <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, akpm <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH -next] fork and exit: need to include iocontext.h
Message-ID: <20080630183337.GD32211@elte.hu>
References: <20080630105458.7c95e195.randy.dunlap@oracle.com> <20080630180506.GC23739@elte.hu> <20080630112222.f103e477.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080630112222.f103e477.randy.dunlap@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 30 Jun 2008 20:05:06 +0200 Ingo Molnar wrote:
> 
> > 
> > * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Fix fork and exit build errors: they need to include iocontext.h:
> > > 
> > > linux-next-20080630/kernel/fork.c: In function 'copy_process':
> > > linux-next-20080630/kernel/fork.c:1237: error: implicit declaration of function 'put_io_context'
> > > linux-next-20080630/kernel/exit.c: In function 'do_exit':
> > > linux-next-20080630/kernel/exit.c:992: error: implicit declaration of function 'exit_io_context'
> > 
> > i havent seen this one - do you know by chance which commit triggers it?
> 
> 
> Sorry, no idea which commit.
> 
> In 50 randconfigs today (next-20080630), I saw this one 12 times.

btw., block.git would be one of my first guesses - Jens Cc:-ed.

normally there's an easy way to find out the source commit of build 
failures. Try something like:

 git-bisect reset
 git-bisect start
 git-bisect good v2.6.26-rc8
 git-bisect bad linux-next/master
 git-bisect run make kernel/fork.o

... this should lead you to the commit that broke the build 
automatically. (as long as everyone keeps make oldconfig compatibility)

	Ingo
