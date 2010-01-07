Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822Ab0AGSAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0AGSAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 13:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711Ab0AGSAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 13:00:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:43180 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab0AGSAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 13:00:48 -0500
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.1001070937180.7821@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>
	 <20100104182813.753545361@chello.nl>
	 <20100105054536.44bf8002@infradead.org>
	 <alpine.DEB.2.00.1001050916300.1074@router.home>
	 <20100105192243.1d6b2213@infradead.org>
	 <alpine.DEB.2.00.1001071007210.901@router.home>
	 <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain>
	 <1262884960.4049.106.camel@laptop>
	 <alpine.LFD.2.00.1001070934060.7821@localhost.localdomain>
	 <alpine.LFD.2.00.1001070937180.7821@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 19:00:07 +0100
Message-ID: <1262887207.4049.127.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 09:49 -0800, Linus Torvalds wrote:
> 
> The thing is, I can pretty much _guarantee_ that the speculative page 
> fault is going to end up doing a lot of nasty stuff that still needs 
> almost-global locking, and it's likely to be more complicated and slower 
> for the single-threaded case (you end up needing refcounts, a new "local" 
> lock or something).

Well, with that sync_vma() thing I posted the other day all the
speculative page fault needs is a write to current->fault_vma, the ptl
and an O(nr_threads) loop on unmap() for file vmas -- aside from writing
the pte itself of course.




