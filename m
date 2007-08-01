Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbXHAXrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbXHAXrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbXHAXrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:47:12 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:57744 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbXHAXrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:47:11 -0400
Subject: Re: SD still better than CFS for 3d   ?(was Re: 2.6.23-rc1)
From: Kasper Sandberg <lkml@metanurb.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
In-Reply-To: <20070731085713.GA15136@elte.hu>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu>
	 <1185839164.27166.7.camel@localhost> <1185863461.3092.4.camel@twins>
	 <20070731085713.GA15136@elte.hu>
Content-Type: text/plain
Date: Thu, 02 Aug 2007 01:43:47 +0200
Message-Id: <1186011827.2482.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 10:57 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, 2007-07-31 at 01:46 +0200, Kasper Sandberg wrote:
> > 
> > > could perhaps be filesystem related, i have my maildir(extremely 
> > > large) on reiserfs, and /home on xfs. what my mail client will do is 
> > > download mail, spamasassin it(loading database from home), then it 
> > > will put to imap server placing it on reiserfs, and then a "local" 
> > > copy in my home.
> > 
> > Ooh, do you perchance have PREEMPT_BKL=y?
> > 

sorry late response.

nope, i run totally without preemption, i did however test with, it
seemed to not matter in terms of smoothness, but reduced the throughput
slightly.

> > If so, try on another filesystem than reiserfs (or disable 
> > PREEMPT_BKL, but that is obviously the lesser of the two choices).
> > 
> > Ingo traced a 1+ second latency at my end to BKL priority inversion 
> > between tty and reiserfs.
> 
> ah, indeed, that makes quite a bit of sense. Almost all of the Reiser3 
> code runs under the BKL, and the only other major kernel infrastructure 
> that has BKL dependencies is the TTY code. Kasper, as a debugging 
> matter, could you try to move that spamassassin workload off into a 
> non-Reiser3 filesystem and/or disable PREEMPT_BKL? If that makes a 
> noticeable difference (for the better ;) then we can continue figuring 
> out what's happening exactly.

the pricess is as this:
mail client fetches mail
mail client invokes spamasassin
 if spam -> spam
 else filtering
if it matches certain filters, it gets put into my imap server, which is
reiserfs.


> 	Ingo

