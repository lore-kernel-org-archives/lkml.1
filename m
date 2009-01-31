Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbZAaNH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbZAaNH1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 08:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZAaNHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 08:07:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35398 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbZAaNHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 08:07:13 -0500
Date: Sat, 31 Jan 2009 14:06:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>
Subject: Re: [patch 3/7] epoll keyed wakeups - introduce key-aware wakeup
	macros
Message-ID: <20090131130646.GA3986@elte.hu>
References: <send-serie.davidel@xmailserver.org.16376.1233372317.3> <20090131033035.GA26640@elte.hu> <alpine.LFD.2.00.0901301953280.3150@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901301953280.3150@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 31 Jan 2009, Ingo Molnar wrote:
> > 
> > Would be nice to see the kernel image size increase due to this change 
> > (which gives a good measure about how much of an issue this is).
> 
> Ingo, I don't think you have looked at that header file for a while.
> 
> It's already doing that, Davide just changed the names a bit:
> 
> 	#define wake_up_interruptible(x)        __wake_up(x, TASK_INTERRUPTIBLE, 1, NULL)
> 
> and the extra parameter is already there in the caller.

Yeah, indeed - i should have noticed the absense of new function 
prototypes in the patch ... and in any case i shouldnt post at 4am ;)

> (Yeah, Davide did add it to __wake_up_locked and __wake_up_sync, but 
> those are really not the common cases).
> 
> Sure, we can change those #define's to be actual functions (and perhaps 
> not export the low-level __wake_up() functions at all), since it's true 
> that it would probably shrink the kernel size, but that is really a 
> totally independent issue from the whole epoll wakeups thing.

Yeah. Will have a look at that independently of Davide's patch.

	Ingo
