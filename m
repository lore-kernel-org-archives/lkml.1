Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056Ab0AGRg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab0AGRg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916Ab0AGRgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:36:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810Ab0AGRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:36:53 -0500
Date: Thu, 7 Jan 2010 09:36:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <1262884960.4049.106.camel@laptop>
Message-ID: <alpine.LFD.2.00.1001070934060.7821@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>  <20100104182813.753545361@chello.nl>  <20100105054536.44bf8002@infradead.org>  <alpine.DEB.2.00.1001050916300.1074@router.home>  <20100105192243.1d6b2213@infradead.org>  <alpine.DEB.2.00.1001071007210.901@router.home>
  <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain> <1262884960.4049.106.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jan 2010, Peter Zijlstra wrote:
> 
> Right, supposing we can make this speculative fault stuff work, then we
> can basically reduce the mmap_sem usage in fault to:
> 
>   - allocating new page tables
>   - extending the growable vmas
> 
> And do everything else without holding it, including zeroing and IO.

Well, I have yet to hear a realistic scenario of _how_ to do it all 
speculatively in the first place, at least not without horribly subtle 
complexity issues. So I'd really rather see how far we can possibly get by 
just improving mmap_sem.

			Linus
