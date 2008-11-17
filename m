Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYKQPuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYKQPuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYKQPui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:50:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33752 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYKQPuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:50:37 -0500
Date: Mon, 17 Nov 2008 16:50:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Doug Chapman <doug.chapman@hp.com>,
       Frank Mayhar <fmayhar@google.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] fix the racy usage of ->signal in
	account_group_xxx/run_posix_cpu_timers
Message-ID: <20081117155009.GA12081@elte.hu>
References: <20081117143947.GA5360@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117143947.GA5360@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> Another stupid patch for 2.6.28 until we find the good fix.
> 
> Contrary to ad474caca3e2a0550b7ce0706527ad5ab389a4d4 changelog, 
> other acct_group_xxx() helpers can be called after exit_notify() by 
> timer tick. Thanks to Roland for pointing out this. Somehow I missed 
> this simple fact when I read the original patch, and I am afraid I 
> confused Frank during the discussion. Sorry.
> 
> Fortunately, these helpers work with current, we can check 
> ->exit_state to ensure that ->signal can't go away under us.
> 
> Also, add the comment and compiler barrier to 
> account_group_exec_runtime(), to make sure we load ->signal only 
> once.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

applied to tip/sched/urgent, thanks Oleg.

	Ingo
