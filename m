Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbZDWVZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbZDWVZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbZDWVY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:24:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57895 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756692AbZDWVY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:24:58 -0400
Date: Thu, 23 Apr 2009 23:24:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, serue@us.ibm.com,
       viro@zeniv.linux.org.uk,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] It may not be assumed that wake_up(), finish_wait()
	and co. imply a memory barrier
Message-ID: <20090423212434.GA20556@elte.hu>
References: <32260.1239658818@redhat.com> <20090413214852.GA1127@redhat.com> <1239659841.16771.26.camel@heimdal.trondhjem.org> <20090413222451.GA2758@redhat.com> <14561.1239873018@redhat.com> <21239.1240407420@redhat.com> <5591.1240417398@redhat.com> <21209.1240504344@redhat.com> <22170.1240518945@redhat.com> <alpine.LFD.2.00.0904231410590.3101@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904231410590.3101@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 23 Apr 2009, David Howells wrote:
> > 
> > Well, Ingo's point is it could be left up to the caller of 
> > wake_up() to supply the barrier:

Well, i mainly reacted to your documentation patch which was 
incorrect as it said wake-up implies a _FULL_ memory barrier.

I also suggested that lockless code should have its barriers clearly 
documented and they should not really rely on kernel facilities 
acting as memory barriers.

Then i also suggested that maybe in the future we could remove the 
smp_wmb() from try_to_wake_up(). That was just an afterthought, and 
a rather stupid one at that, as Linus quickly noted :-)

	Ingo
