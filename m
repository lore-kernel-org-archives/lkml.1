Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbZEKKVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbZEKKVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 06:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZEKKVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 06:21:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60271 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZEKKVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 06:21:45 -0400
Date: Mon, 11 May 2009 12:20:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Split wait_noreap_copyout()
Message-ID: <20090511102050.GA4648@elte.hu>
References: <1242036759-4025-1-git-send-email-v.mayatskih@gmail.com> <1242036759-4025-2-git-send-email-v.mayatskih@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242036759-4025-2-git-send-email-v.mayatskih@gmail.com>
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


* Vitaly Mayatskikh <v.mayatskih@gmail.com> wrote:

> -static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
> -				pid_t pid, uid_t uid, int why, int status)
> +static int wait_copyout(struct wait_opts *wo, struct task_struct *p,
> +			pid_t pid, uid_t uid, int why, int status, int signal)

Nice cleanups. Would be nice to fix the naming here too while at it.

Right now it's two verbs and a straightforward reading of it suggest 
that we 'wait for some copyout to occur', which is nonsensical and 
confusing.

So please put the main action as the first verb (this is an internal 
symbol so no subsystem differentiator is needed). Something like:

  copy_wait_opts_to_user()

... and it becomes a whole lot easier to read. This matches the 
copy*to_user idioms we have elsewhere so it nicely wibes with the 
sound of those.

( Now repeat similar measures on the whole tree, a hundred thousand 
  times or so, and enforce it for all new patches, and we'd have
  crisp, consistent, highly readable and enjoyable kernel source ;-)

Thanks,

	Ingo
