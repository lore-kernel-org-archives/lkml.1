Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYKSQOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYKSQOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 11:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYKSQOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 11:14:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbYKSQOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 11:14:39 -0500
Subject: Re: Active waiting with yield()
From: Peter Zijlstra <peterz@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rml@tech9.net, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0811181157260.13418@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
	 <20081114190616.30dd273e@lxorguk.ukuu.org.uk>
	 <Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com>
	 <1226696221.7685.8148.camel@twins>
	 <Pine.LNX.4.64.0811141630590.6783@hs20-bc2-1.build.redhat.com>
	 <1226789714.8172.0.camel@lappy.programming.kicks-ass.net>
	 <Pine.LNX.4.64.0811171228500.4019@hs20-bc2-1.build.redhat.com>
	 <20081117180149.7a48d2e9@lxorguk.ukuu.org.uk>
	 <Pine.LNX.4.64.0811180921450.12274@hs20-bc2-1.build.redhat.com>
	 <20081118144053.0072d54c@lxorguk.ukuu.org.uk>
	 <Pine.LNX.4.64.0811181157260.13418@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 17:14:21 +0100
Message-Id: <1227111261.29743.26.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-18 at 12:11 -0500, Mikulas Patocka wrote:
> On Tue, 18 Nov 2008, Alan Cox wrote:
> 
> > > You will touch the wait queue always when finishing the last pending 
> > > request --- just to find out that there is no one waiting on it.
> > 
> > Why ? If my fast path for this something like
> > 
> > 	if (unlikely(foo->unload_pending) && count == 0)
> > 		wake_up(..)
> > 
> > chances are that I can put unload_pending somewhere in a cache line with
> > other stuff (certainly for L2) and it will get predicted well.
> 
> This makes a code branch that is very rarely tested and a potential bug. 
> Every such rarely executed branch is a danger and even a silly typo in the 
> code can hide there for many years without being noticed.

If you cannot get these simple things right, and stubbornly refuse to
listen to people telling you to the kernel is not the place to cut
corners, perhaps you should not be doing kernel code.


