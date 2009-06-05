Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbZFERZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbZFERZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZFERY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:24:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbZFERY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:24:57 -0400
Date: Fri, 5 Jun 2009 10:24:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com, mingo@elte.hu
Subject: Re: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
Message-Id: <20090605102440.58a6e443.akpm@linux-foundation.org>
In-Reply-To: <20090605093725.GC23657@alberich.amd.com>
References: <200906050038.n550c4Ja010907@www262.sakura.ne.jp>
	<20090605023835.GA7933@cr0.nay.redhat.com>
	<20090604201733.746928c6.akpm@linux-foundation.org>
	<200906050339.n553d684048041@www262.sakura.ne.jp>
	<20090604205103.bbfe9af2.akpm@linux-foundation.org>
	<200906050400.n5540Sx0052981@www262.sakura.ne.jp>
	<20090604212018.b9e9f354.akpm@linux-foundation.org>
	<200906050651.n556p7Vo094549@www262.sakura.ne.jp>
	<20090605000310.a5b8fa56.akpm@linux-foundation.org>
	<20090605093725.GC23657@alberich.amd.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 11:37:25 +0200 Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> On Fri, Jun 05, 2009 at 12:03:10AM -0700, Andrew Morton wrote:
> > On Fri, 05 Jun 2009 15:51:07 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > 
> > > >but I wonder why all those things are u64.  They all hold virtual
> > > >addresses, don't they?  The code doesn't test highmem.  So shouldn't
> > > >these all be unsigned longs?
> > > memtest() in linux-2.6.29.4/arch/x86/mm/memtest.c is using "unsigned long".
> > > 2.6.30 changed to use "u64" by some reason.
> > 
> > No reason, really.  "consistency". 
> 
> Yes, it was done that way for consistency.
> See this thread
>   http://lkml.org/lkml/2009/2/13/166
> 
> > It made the code slower,
> 
> not measurable
> 
> > larger
> 
> slightly on 32-bit
> 
> > and, err, not compile.
> 
> Mea culpa.
> 
> Overlooked the 64-bit division.
> Did test this with 4.[23].x compilers on 32-bit which didn't complain ...
> 
> I assume you are going to send your do_div() fix upstream?
> 

I deleted it, for it is lame.

A better fix is to use the correct types.
