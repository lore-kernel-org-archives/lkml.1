Return-Path: <linux-kernel-owner+w=401wt.eu-S1751257AbZLRFSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbZLRFSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 00:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbZLRFSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 00:18:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58115 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbZLRFSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 00:18:11 -0500
Date: Fri, 18 Dec 2009 06:17:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
Message-ID: <20091218051754.GC417@elte.hu>
References: <20091217084046.GA9804@basil.fritz.box>
 <1261039534.27920.67.camel@laptop>
 <20091217085430.GG9804@basil.fritz.box>
 <20091217144551.GA6819@linux.vnet.ibm.com>
 <20091217175338.GL9804@basil.fritz.box>
 <20091217190804.GB6788@linux.vnet.ibm.com>
 <20091217195530.GM9804@basil.fritz.box>
 <alpine.DEB.2.00.0912171356020.4640@router.home>
 <1261080855.27920.807.camel@laptop>
 <alpine.DEB.2.00.0912171439380.4640@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912171439380.4640@router.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 17 Dec 2009, Peter Zijlstra wrote:
> 
> > > That is why I think that the accessors are a good first step.
> >
> > They're not, they're daft, they operate on a global resource mm_struct, 
> > that's the whole problem, giving it a different name isn't going to solve 
> > anything.
> 
> It is not about naming. The accessors hide the locking mechanism for 
> mmap_sem. Then you can change the locking in a central place.
> 
> The locking may even become configurable later. Maybe an embedded solution 
> will want the existing scheme but dual quad socket may want a distributed 
> reference counter to avoid bouncing cachelines on faults.

Hiding the locking is pretty much the worst design decision one can make.

	Ingo
