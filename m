Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbYFILlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbYFILlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759773AbYFILlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:41:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43489 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759591AbYFILlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:41:44 -0400
Date: Mon, 9 Jun 2008 13:41:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [regression][bisected] ~90,000 wakeups as of 2.6.26-rc3
Message-ID: <20080609114132.GA5028@elte.hu>
References: <4844D414.7010402@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4844D414.7010402@freemail.hu>
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


* Németh Márton <nm127@freemail.hu> wrote:

> Hi,
> 
> there is a problem in 2.6.26-rc3 which was not there in case of 
> 2.6.25: the CPU wakes up ~90,000 times per sec instead of ~60 per sec.
> 
> I also "git bisected" the problem, the result is:
> 
> 6e908947b4995bc0e551a8257c586d5c3e428201 is first bad commit
> commit 6e908947b4995bc0e551a8257c586d5c3e428201
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Mar 21 14:32:36 2008 +0100
> 
>     x86: fix ioapic bug again

thanks for tracking this down. Could you check whether the problem is 
also fixed in latest -tip? In particular the tip/x86/apic branch should 
properly solve this. You can pick up -tip via:

  http://people.redhat.com/mingo/tip.git/README

but those tip/x86/apic fixes are too intrusive for v2.6.26, so i've 
queued up your revert into tip/x86/urgent, for v2.6.26 merging. Would be 
nice if you could check -tip though, to make sure we dont reintroduce 
the same problem again in v2.6.27.

	Ingo
