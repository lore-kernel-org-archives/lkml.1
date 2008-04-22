Return-Path: <linux-kernel-owner+w=401wt.eu-S1763553AbYDVT0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763553AbYDVT0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbYDVT03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:26:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53544 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237AbYDVT02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:26:28 -0400
Date: Tue, 22 Apr 2008 21:26:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       npiggin@suse.de, peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function
	calls
Message-ID: <20080422192601.GB12588@elte.hu>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-3-git-send-email-jens.axboe@oracle.com> <alpine.LFD.1.10.0804221157220.2779@woody.linux-foundation.org> <20080422191213.GA6370@elte.hu> <alpine.LFD.1.10.0804221218410.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804221218410.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > yes and i gave in - Nick and Jens wants to do some crazy stuff and 
> > they had the numbers. Here's the previous discussion:
> > 
> >   http://lkml.org/lkml/2008/2/27/125
> 
> No, the previous discussion was about single *queues* vs single 
> *vectors*.
> 
> I agree unconditionally with the decision to use a separate per-cpu 
> queue from the shared queue (in fact, I would argue that the "mask" 
> code might want to notice when the mask is just a single CPU, and turn 
> a mask request into a targeted request).
> 
> But I wonder why we want to then have two IPI target vectors, when it 
> would appear to be perfectly fine and cheap to have just a single 
> vector that can handle both the per-cpu case and the shared queue case 
> (since the thing would tend to be one or the other, not both).
> 
> A single vector is still pefectly fine, if 99% of all usage cases are 
> the targeted-to-a-single-cpu thing, because the shared queue will 
> basically be empty (and you can test that without even taking any 
> locks).

ok. In which case the reschedule vector could be consolidated into that 
as well (it's just a special single-CPU call). Then there would be no 
new vector allocations needed at all, just the renaming of 
RESCHEDULE_VECTOR to something more generic.

	Ingo
