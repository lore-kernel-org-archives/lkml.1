Return-Path: <linux-kernel-owner+w=401wt.eu-S1751209AbXDKIW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbXDKIW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXDKIWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:22:25 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:51550 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbXDKIWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:22:24 -0400
Date: Wed, 11 Apr 2007 10:14:58 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, take4] FUTEX : new PRIVATE futexes
Message-Id: <20070411101458.114125ee.dada1@cosmosbay.com>
In-Reply-To: <461C8CD1.3080707@yahoo.com.au>
References: <20060808070708.GA3931@localhost.localdomain>
	<200608090826.28249.dada1@cosmosbay.com>
	<200608090843.52893.dada1@cosmosbay.com>
	<200703152010.35614.dada1@cosmosbay.com>
	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	<20070405194942.1414c030.dada1@cosmosbay.com>
	<20070407104339.6674336b.dada1@cosmosbay.com>
	<461764A6.3080703@yahoo.com.au>
	<20070407120051.9ed0e69a.dada1@cosmosbay.com>
	<461C8CD1.3080707@yahoo.com.au>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 17:22:57 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Eric Dumazet wrote:
> > On Sat, 07 Apr 2007 19:30:14 +1000
> > Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > 
> > 
> >>Eric Dumazet wrote:
> > 
> >  
> > 
> >>>- Current mm code have a problem with 64bit futexes, as spoted by Nick :
> >>>
> >>>get_futex_key() does a check against sizeof(u32) regardless of futex being 64bits or not.
> >>>So it is possible a 64bit futex spans two pages of memory...
> >>>I had to change get_futex_key() prototype to be able to do a correct test.
> >>
> >>I wonder if it should be encfocing alignment to keep in on 1 page?
> > 
> > 
> > I believe I just did that :)
> 
> Yes :P What I was trying to say before jumping on a plane is that
> sys_futex/sys_futex64 calls should each check their own address alignment, so
> the deeper parts of the call stack always know alignment is correct.
> 
> This will remove all the fsize you pass around, and also sanitise the userspace
> argument much higher in the call stack, which is very preferable and more
> conventional.
> 
> Maybe this isn't possible (it's very obvious, so there may be a good reason it
> hasn't been done).

I had this idea as well, but considering get_futex_key() is exported in include/linux/futex.h, I believe some out-of tree thing is using it.

As this external thing certainly is not doing the check itself, to be on the safe side we should enforce it in get_futex_key(). I agree with you : If we want to maximize performance, we could say : The check *must* be done by the caller.

