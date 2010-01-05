Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804Ab0AEPSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0AEPSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862Ab0AEPSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:18:15 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:33751 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab0AEPSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:18:11 -0500
Date: Tue, 5 Jan 2010 09:17:11 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Arjan van de Ven <arjan@infradead.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <20100105054536.44bf8002@infradead.org>
Message-ID: <alpine.DEB.2.00.1001050916300.1074@router.home>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105054536.44bf8002@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Arjan van de Ven wrote:

> while I appreciate the goal of reducing contention on this lock...
> wouldn't step one be to remove the page zeroing from under this lock?
> that's by far (easily by 10x I would guess) the most expensive thing
> that's done under the lock, and I would expect a first order of
> contention reduction just by having the zeroing of a page not done
> under the lock...

The main issue is cacheline bouncing. mmap sem is a rw semaphore and only
held for read during a fault.

