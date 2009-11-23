Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbZKWP7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbZKWP7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbZKWP7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:59:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbZKWP7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:59:23 -0500
Date: Mon, 23 Nov 2009 17:58:51 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       riel@redhat.com
Subject: Re: [PATCH v2 10/12] Maintain preemptability count even for
 !CONFIG_PREEMPT kernels
Message-ID: <20091123155851.GU2999@redhat.com>
References: <1258985167-29178-1-git-send-email-gleb@redhat.com>
 <1258985167-29178-11-git-send-email-gleb@redhat.com>
 <1258990455.4531.594.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258990455.4531.594.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 04:34:15PM +0100, Peter Zijlstra wrote:
> On Mon, 2009-11-23 at 16:06 +0200, Gleb Natapov wrote:
> > Do not preempt kernel. Just maintain counter to know if task can be rescheduled.
> > Asynchronous page fault may be delivered while spinlock is held or current
> > process can't be preempted for other reasons. KVM uses preempt_count() to check if preemptions is allowed and schedule other process if possible. This works
> > with preemptable kernels since they maintain accurate information about
> > preemptability in preempt_count. This patch make non-preemptable kernel
> > maintain accurate information in preempt_count too.
> 
> I'm thinking you're going to have to convince some people this won't
> slow them down for no good.
> 
I saw old discussions about this in mailing list archives. Usually
someone wanted to use in_atomic() in driver code and this, of course,
caused the resistant. In this case, I think, the use is legitimate.

> Personally I always have PREEMPT=y, but other people seem to feel
> strongly about not doing so.
> 
It is possible to add one more config option to enable reliable
preempt_count() without enabling preemption or make async pf be
dependable on PREEMPT=y. Don't like both of this options especially first
one. There are more then enough options already.

--
			Gleb.
