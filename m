Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbXFDQ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbXFDQ5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759345AbXFDQ5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:57:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46160 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759201AbXFDQ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:57:07 -0400
Date: Mon, 4 Jun 2007 09:56:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
Message-Id: <20070604095605.66e04153.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706040533210.30231@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
	<46633047.1020707@cosmosbay.com>
	<Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
	<20070603230859.5000424d.akpm@linux-foundation.org>
	<20070604080537.GA22898@elte.hu>
	<20070604080941.GA23537@elte.hu>
	<20070604013449.ea3acca8.akpm@linux-foundation.org>
	<20070604084227.GA29446@elte.hu>
	<20070604014759.aaa3b051.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706040533210.30231@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007 06:05:22 -0700 (PDT) Davide Libenzi <davidel@xmailserver.org> wrote:

> On Mon, 4 Jun 2007, Andrew Morton wrote:
> 
> > a) Were IDR trees evaluated and if so, why were they rejected?
> > 
> > b) it's a bit disappointing that this new allocator is only usable for
> >    one specific application.  We have a *lot* of places in the kernel which
> >    want allocators of this type.  Many of them are open-coded and crappy. 
> >    Some use IDR trees.
> > 
> >    If we're going to go and add a complete new allocator, it would be
> >    good to position it as a library thing if poss.
> 
> Thank you for pointing me to that, Andrew. I didn't know about it (IDR 
> trees).
> It does not fit AFAICS.
> Locking should be handled extarnally (the files 
> struct),

Yeah, that's already a problem in IDR and I'm hoping sometime someone will
be inspired to redo it, move it to caller-provided locking.

> must be RCU friendly (proper barriers) since it's used in 
> lockless code,

Haven't looked at that.

> and must have flags associated to an allocation.

Don't understand that.

> And I'm 
> leaving out the O(1) part, that for something like this, is just silly not 
> to have it. This is really an array.

Having to walk down a tree in fget_light() would kinda suck.

What about my b)?
