Return-Path: <linux-kernel-owner+w=401wt.eu-S1762482AbXEKRTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762482AbXEKRTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 13:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXEKRT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 13:19:28 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:59443 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751658AbXEKRT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 13:19:27 -0400
Subject: Re: [PATCH 2/2] mm: change mmap_sem over to the scalable rw_mutex
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <20070511091744.236e8409.akpm@linux-foundation.org>
References: <20070511131541.992688403@chello.nl>
	 <20070511132321.984615201@chello.nl>
	 <20070511091744.236e8409.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 11 May 2007 19:12:16 +0200
Message-Id: <1178903537.2781.13.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(now with reply-all)

On Fri, 2007-05-11 at 09:17 -0700, Andrew Morton wrote:
> On Fri, 11 May 2007 15:15:43 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > -	down_write(&current->mm->mmap_sem);
> > +	rw_mutex_write_lock(&current->mm->mmap_lock);
> 
> y'know, this is such an important lock and people have had such problems
> with it and so many different schemes and ideas have popped up that I'm
> kinda thinking that we should wrap it:
> 
> 	write_lock_mm(struct mm_struct *mm);
> 	write_unlock_mm(struct mm_struct *mm);
> 	read_lock_mm(struct mm_struct *mm);
> 	read_unlock_mm(struct mm_struct *mm);
> 
> so that further experimentations become easier?

Sure, can do; it'd require a few more functions than these, but its not
too many. However, what is the best way to go about such massive rename
actions? Just push them through quickly, and make everybody cope?

