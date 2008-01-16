Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbYAPIM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbYAPIM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 03:12:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYAPIMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 03:12:19 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbYAPIMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 03:12:18 -0500
Date: Wed, 16 Jan 2008 09:11:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: 2.6.24-rc7 lockdep warning when poweroff
Message-ID: <20080116081155.GA10019@elte.hu>
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com> <1200302644.7415.6.camel@twins> <1200306902.5887.39.camel@johannes.berg> <1200307288.7415.11.camel@twins> <1200307896.5887.42.camel@johannes.berg> <1200393685.5887.113.camel@johannes.berg> <1200399661.26045.13.camel@twins> <1200400787.5887.129.camel@johannes.berg> <1200401245.26045.19.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200401245.26045.19.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> > > The patch looks ok, one important thing to note is that it means 
> > > that all workqueues instantiated by the same __create_workqueue() 
> > > call-site share lock dependency chains - I'm unsure if that might 
> > > get us into trouble or not.
> > 
> > It doesn't seem to have so far ;) I don't think it should. If some 
> > code allocates a per-instance workqueue that's much like having an 
> > inode lock or so.
> 
> We had to split up the inode lock to per filesystem classes, just 
> because the lock chains were conflicting between them...

i.e. filesystems can legally have different locking rules wrt. i_lock. I 
dont really like it (we should have as simple locking rules as possible) 
but it is the VFS status quo :)

	Ingo
