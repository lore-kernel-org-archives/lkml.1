Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214Ab0AENnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0AENnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:43:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186Ab0AENnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:43:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:53965 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab0AENnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:43:14 -0500
Date: Tue, 5 Jan 2010 05:45:36 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-ID: <20100105054536.44bf8002@infradead.org>
In-Reply-To: <20100104182813.753545361@chello.nl>
References: <20100104182429.833180340@chello.nl>
	<20100104182813.753545361@chello.nl>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Jan 2010 19:24:35 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Generic speculative fault handler, tries to service a pagefault
> without holding mmap_sem.


while I appreciate the goal of reducing contention on this lock...
wouldn't step one be to remove the page zeroing from under this lock?
that's by far (easily by 10x I would guess) the most expensive thing
that's done under the lock, and I would expect a first order of
contention reduction just by having the zeroing of a page not done
under the lock...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
