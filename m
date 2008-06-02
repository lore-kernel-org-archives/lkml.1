Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbYFBKj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbYFBKj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbYFBKjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:39:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55212 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbYFBKjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:39:47 -0400
Date: Mon, 2 Jun 2008 12:39:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] softlockup: fix NMI hangs due to lock race - 2.6.26-rc
	regression
Message-ID: <20080602103931.GA898@elte.hu>
References: <483C4391.8040002@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483C4391.8040002@windriver.com>
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


* Jason Wessel <jason.wessel@windriver.com> wrote:

> The touch_nmi_watchdog() routine on x86 ultimately calls 
> touch_softlockup_watchdog().  The problem is that to touch the 
> softlockup watchdog, the cpu_clock code has to be called which could 
> involve multiple cpu locks and can lead to a hard hang if one of the 
> locks is held by a processor that is not going to return anytime soon 
> (such as could be the case with kgdb or perhaps even with some other 
> kind of exception).
> 
> This patch causes the public version of the 
> touch_softlockup_watchdog() to defer the cpu clock access to a later 
> point.

applied to tip/core/softlockup and cherry-picked it into tip/core/urgent 
as well for v2.6.26 merge. Thanks,

	Ingo
