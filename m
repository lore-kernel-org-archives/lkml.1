Return-Path: <linux-kernel-owner+w=401wt.eu-S1761597AbYGRWUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597AbYGRWUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757232AbYGRWUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:20:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55016 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981AbYGRWUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:20:08 -0400
Date: Sat, 19 Jul 2008 00:19:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] generic ipi function calls: wait on alloc failure
	fallback
Message-ID: <20080718221922.GC31073@elte.hu>
References: <487D0719.9000503@goop.org> <20080715214819.GA23588@elte.hu> <487D1E1E.9060609@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D1E1E.9060609@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> does this explain the xen64 weirdnesses you've been seeing?
>>   
>
> No, but I haven't seen it lately.  I think the other RCU fixes may 
> have helped.  But it's all a bit of a worry: I didn't have a good 
> theory about what was going wrong, the RCU patches didn't look like 
> they'd fix the symptoms I was seeing.
>
> I've seen it with 32 and 64-bit Xen, but there's nothing about the 
> problem which makes me think it's really Xen specific.  If it were, 
> I'd expect to see failures all over the place, rather than in just in 
> this one specific place.
>
> I'm concerned there's a lurking bug, particularly if it's a generic 
> race or something that happens to be triggered when running under Xen 
> because of the timing changes.  I've tried reproducing it in a hvm Xen 
> domain (so it's running the normal x86 kernel fully virtualized, but 
> with the Xen scheduler, etc).  I didn't see a problem, but it isn't a 
> very convincing test one way or the other.

ok. I doubt there's much we can do at this stage - the code looks fine. 
If it's some recently added core kernel problem sooner or later some 
workload or hw will come about that shows it in a more debuggable 
manner.

	Ingo
