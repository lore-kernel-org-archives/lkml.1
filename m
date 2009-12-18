Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbZLRSps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbZLRSps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZLRSpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:45:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55802 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbZLRSpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:45:45 -0500
Date: Fri, 18 Dec 2009 19:45:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
Message-ID: <20091218184504.GA675@elte.hu>
References: <20091217175338.GL9804@basil.fritz.box>
 <20091217190804.GB6788@linux.vnet.ibm.com>
 <20091217195530.GM9804@basil.fritz.box>
 <alpine.DEB.2.00.0912171356020.4640@router.home>
 <1261080855.27920.807.camel@laptop>
 <alpine.DEB.2.00.0912171439380.4640@router.home>
 <20091218051754.GC417@elte.hu>
 <4B2BB52A.7050103@redhat.com>
 <20091218171240.GB1354@elte.hu>
 <alpine.DEB.2.00.0912181207010.26947@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912181207010.26947@router.home>
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

> > We've been through this many times in the past within the kernel: many 
> > times when we hid some locking primitive within some clever wrapping 
> > scheme the quality of locking started to deteriorate. In most of the 
> > important cases we got rid of the indirection and went with an existing 
> > core kernel locking primitive which are all well known and have clear 
> > semantics and lead to more maintainable code.
> 
> The existing locking APIs are all hiding lock details at various levels. We 
> have various specific APIs for specialized locks already Page locking etc.

You need to loo at the patches. This is simply a step backwards:

-               up_read(&mm->mmap_sem);
+               mm_read_unlock(mm);

because it hides the lock instance.

( You brought up -rt but that example does not apply: it doesnt 'hide' the 
  lock instance in any way, it simply changes the preemption model. It goes to 
  great lengths to keep existing locking patterns and does not obfuscate 
  locking. )

	Ingo
