Return-Path: <linux-kernel-owner+w=401wt.eu-S1763782AbYDOBmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763782AbYDOBmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 21:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760106AbYDOBlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 21:41:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763599AbYDOBlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 21:41:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace children revamp
In-Reply-To: Oleg Nesterov's message of  Sunday, 13 April 2008 18:24:01 +0400 <20080413142401.GA532@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain>
	<20080329033542.BFF4526FA1D@magilla.localdomain>
	<20080329103929.GB359@tv-sign.ru>
	<20080329131019.GA472@tv-sign.ru>
	<20080404210033.F26CC26F8DC@magilla.localdomain>
	<20080405140656.GA109@tv-sign.ru>
	<20080409201555.7D23626F98D@magilla.localdomain>
	<20080413142401.GA532@tv-sign.ru>
X-Zippy-Says: I was making donuts and now I'm on a bus!
Message-Id: <20080415014110.88DFA26FA5F@magilla.localdomain>
Date: Mon, 14 Apr 2008 18:41:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry for delay!

There's no need to apologize!  I heartily appreciate all your help on this.

> Agreed. I never understood why we need __WNOTHREAD. The same for
> ->pdeath_signal in its current "per-thread" form. I think it would be
> very nice to kill them both (or send the ->pdeath_signal when the whole
> process exits). Then we can place all childrens on one signal->children
> list. But this is a bit off-topic for now.

I'm in complete agreement here, but indeed it's to be considered later.
I never understood pdeath_signal, but I recall someone piping up before
and saying it really was used with its current semantics, so go figure.
(Btw, we can move ->children and still keep __WNOTHREAD compatibility.
It just has to check p->parent == current for __WNOTHREAD.  We can do
that if we determine that __WNOTHREAD is purely for anal backward
compatibility, and noone cares about the performance difference of
__WNOTHREAD calls only looping over a shorter list.)

> I think the 4th patch has a small problem,

Thanks.  I think we're moving on to the other variant of the patch now,
so I won't worry about fixing up the version we're abandoning.  

> Yes! I thought about this too. Actually, I was very sure that this is your
> plan from the the very beginning ;)

You were quite right!  I somehow tricked myself into trying something
inferior first.  Silly me.  :-)


Thanks,
Roland
