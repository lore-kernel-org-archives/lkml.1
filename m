Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbZC1TyE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbZC1TyE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 15:54:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759210AbZC1TwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 15:52:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759227AbZC1TwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 15:52:17 -0400
Date: Sat, 28 Mar 2009 12:43:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-Id: <20090328124303.d902fb57.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0903271508520.3994@localhost.localdomain>
References: <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	<20090325185824.GO32307@mit.edu>
	<alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
	<20090325215137.GQ32307@mit.edu>
	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326181106.GC17159@duck.suse.cz>
	<alpine.LFD.2.00.0903261534490.3032@localhost.localdomain>
	<20090326155725.c2150ab2.akpm@linux-foundation.org>
	<20090327213806.GG31071@duck.suse.cz>
	<alpine.LFD.2.00.0903271508520.3994@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 15:10:56 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 27 Mar 2009, Jan Kara wrote:
> >
> >   Doable but not fairly simple ;) Firstly you have to restart a transaction
> > when you've used up all the credits you originally started with (easy),
> > secondly ext3 uses lock order PageLock -> "transaction start" which is
> > unusable for the scheme you suggest. So we'd have to revert that - which
> > needs larger audit of our locking scheme and that's probably the reason
> > why noone has done it yet.
> 
> It's also not clear that ext3 can really do much better than the regular 
> generic_writepages() logic. I mean, seriously, what's there to improve on? 

- opening a single transaction for many pages in the cases when a
  transaction _is_ needed.

- single large BIO versus zillions of single-page BIOs.

Relatively minor benefits, but it's a bit odd that we never got around
to doing it.

It just got quite a bit harder to do, so I expect we won't be doing it.

