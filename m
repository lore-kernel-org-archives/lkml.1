Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYHMSAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYHMSAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYHMSAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:00:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52952 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbYHMSAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:00:08 -0400
Date: Wed, 13 Aug 2008 19:59:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Huang Ying <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH] kexec jump: fix compiling warning on xchg(&kexec_lock,
	0) in kernel_kexec()
Message-ID: <20080813175915.GA3938@elte.hu>
References: <1218618760.24951.137.camel@caritas-dev.intel.com> <20080813022712.4bea5fea.akpm@linux-foundation.org> <alpine.LFD.1.10.0808130958220.3462@nehalem.linux-foundation.org> <20080813102504.7ce478eb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813102504.7ce478eb.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > instead? Not that that's really right either, but at least it avoids 
> > the _ridiculous_ crap. The real solution is probably to use a 
> > spinlock and trylock/unlock.
> 
> Or test_and_set_bit().  That's what I've been saying too, only 
> differently ;)
> 
> But cleaning up the long-standing silly usage of xchg() is a different 
> activity from suppressing this recently-added compile warning.

actually, in this case i disagree: the warning here is a canary that 
there's something wrong about this code - i.e. gcc is _right_ about 
warning us. The warning is also totally harmless - the warning shows us 
the suckiness of the code structure - and squashing the warning doesnt 
fix that.

So im coal-mine analogies, i disagree with squashing the canary, we 
should find and fix the shaft that emits the smelly methane instead ;-)

	Ingo
