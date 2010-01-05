Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561Ab0AEUaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab0AEUaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505Ab0AEUaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:30:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46884 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab0AEUaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:30:20 -0500
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.1001051019280.3630@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>
	 <20100104182813.753545361@chello.nl>
	 <20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
	 <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain>
	 <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain>
	 <alpine.LFD.2.00.1001050810380.3630@localhost.localdomain>
	 <87wrzwbh0z.fsf@basil.nowhere.org>
	 <alpine.LFD.2.00.1001050950500.3630@localhost.localdomain>
	 <alpine.DEB.2.00.1001051211000.2246@router.home>
	 <alpine.LFD.2.00.1001051019280.3630@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Jan 2010 21:29:16 +0100
Message-ID: <1262723356.4049.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 10:25 -0800, Linus Torvalds wrote:
> The readers are all hitting the 
> lock (and you can try to solve the O(n*2) issue with back-off, but quite 
> frankly, anybody who does that has basically already lost 

/me sneaks in a reference to local spinning spinlocks just to have them
mentioned.

