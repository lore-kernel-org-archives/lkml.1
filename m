Return-Path: <linux-kernel-owner+w=401wt.eu-S1762529AbXEKQTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762529AbXEKQTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 12:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759642AbXEKQTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 12:19:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759631AbXEKQTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 12:19:30 -0400
Date: Fri, 11 May 2007 09:17:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 2/2] mm: change mmap_sem over to the scalable rw_mutex
Message-Id: <20070511091744.236e8409.akpm@linux-foundation.org>
In-Reply-To: <20070511132321.984615201@chello.nl>
References: <20070511131541.992688403@chello.nl>
	<20070511132321.984615201@chello.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 15:15:43 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> -	down_write(&current->mm->mmap_sem);
> +	rw_mutex_write_lock(&current->mm->mmap_lock);

y'know, this is such an important lock and people have had such problems
with it and so many different schemes and ideas have popped up that I'm
kinda thinking that we should wrap it:

	write_lock_mm(struct mm_struct *mm);
	write_unlock_mm(struct mm_struct *mm);
	read_lock_mm(struct mm_struct *mm);
	read_unlock_mm(struct mm_struct *mm);

so that further experimentations become easier?
