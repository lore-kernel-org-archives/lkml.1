Return-Path: <linux-kernel-owner+w=401wt.eu-S1032938AbXENL7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032938AbXENL7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032560AbXENLyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:54:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032462AbXENLyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:54:15 -0400
Date: Mon, 14 May 2007 13:54:13 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] mm: change mmap_sem over to the scalable rw_mutex
Message-ID: <20070514115413.GC31234@wotan.suse.de>
References: <20070511131541.992688403@chello.nl> <20070511132321.984615201@chello.nl> <20070511091744.236e8409.akpm@linux-foundation.org> <1178903537.2781.13.camel@lappy> <20070511110824.a617c679.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511110824.a617c679.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 11:08:24AM -0700, Andrew Morton wrote:
> On Fri, 11 May 2007 19:12:16 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > (now with reply-all)
> > 
> > On Fri, 2007-05-11 at 09:17 -0700, Andrew Morton wrote:
> > > On Fri, 11 May 2007 15:15:43 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > > -	down_write(&current->mm->mmap_sem);
> > > > +	rw_mutex_write_lock(&current->mm->mmap_lock);
> > > 
> > > y'know, this is such an important lock and people have had such problems
> > > with it and so many different schemes and ideas have popped up that I'm
> > > kinda thinking that we should wrap it:
> > > 
> > > 	write_lock_mm(struct mm_struct *mm);
> > > 	write_unlock_mm(struct mm_struct *mm);
> > > 	read_lock_mm(struct mm_struct *mm);
> > > 	read_unlock_mm(struct mm_struct *mm);
> > > 
> > > so that further experimentations become easier?
> > 
> > Sure, can do; it'd require a few more functions than these, but its not
> > too many. However, what is the best way to go about such massive rename
> > actions? Just push them through quickly, and make everybody cope?
> 
> Well, if we _do_ decide to do this (is anyone howling?) then we can do
> 
> static inline void write_lock_mm(struct mm_struct *mm)
> {
> 	down_write(&mm->mmap_sem);
> }

I think that would be fine to do.
