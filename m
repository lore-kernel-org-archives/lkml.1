Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab0BRKzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:55:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51523 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab0BRKzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:55:39 -0500
Date: Thu, 18 Feb 2010 11:55:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH] x86 rwsem optimization extreme
Message-ID: <20100218105506.GA9944@elte.hu>
References: <1266443901-3646-1-git-send-email-zamsden@redhat.com>
 <alpine.LFD.2.00.1002171403160.4141@localhost.localdomain>
 <4B7C7BE4.9050908@zytor.com>
 <alpine.LFD.2.00.1002171743200.4141@localhost.localdomain>
 <4B7C9F0A.1080708@zytor.com>
 <4B7CC14F.7000802@redhat.com>
 <87iq9v55em.fsf@basil.nowhere.org>
 <4B7CF95A.4040706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7CF95A.4040706@redhat.com>
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


* Zachary Amsden <zamsden@redhat.com> wrote:

> >
> >Zachary Amsden<zamsden@redhat.com>  writes
> >>Incidentally, the cost of putting all the rwsem code inline, using the
> >>straightforward approach, for git-tip, using defconfig on x86_64 is
> >>3565 bytes / 20971778 bytes total, or 0.0168%, using gcc 4.4.3.
> >The nice advantage of putting lock code inline is that it gets
> >accounted to the caller in all profilers.
> >
> >-Andi
> >
> 
> Unfortunately, only for the uncontended case.  The hot case still ends up 
> in a call to the lock text section.

Nor is it really true that it's 'a problem for profilers' - call graph
recording works just fine, in fact it can be better for a call-graph record
if the locking sites are not sprinkled around the kernel and inlined.

	Ingo
