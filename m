Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634Ab0AEOPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0AEOPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 09:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631Ab0AEOP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 09:15:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52913 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab0AEOPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 09:15:25 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
From: Andi Kleen <andi@firstfloor.org>
References: <20100104182429.833180340@chello.nl>
	<20100104182813.753545361@chello.nl>
	<20100105054536.44bf8002@infradead.org>
Date: Tue, 05 Jan 2010 15:15:15 +0100
In-Reply-To: <20100105054536.44bf8002@infradead.org> (Arjan van de Ven's message of "Tue, 5 Jan 2010 05:45:36 -0800")
Message-ID: <87637gd4ek.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Mon, 04 Jan 2010 19:24:35 +0100
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>> Generic speculative fault handler, tries to service a pagefault
>> without holding mmap_sem.
>
>
> while I appreciate the goal of reducing contention on this lock...
> wouldn't step one be to remove the page zeroing from under this lock?
> that's by far (easily by 10x I would guess) the most expensive thing
> that's done under the lock, and I would expect a first order of
> contention reduction just by having the zeroing of a page not done
> under the lock...

The cache line bouncing of the shared cache lines hurts too.

I suspect fixing this all properly will need some deeper changes.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
