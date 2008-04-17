Return-Path: <linux-kernel-owner+w=401wt.eu-S1763881AbYDQND3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763881AbYDQND3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 09:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbYDQNDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 09:03:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59599 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbYDQNDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 09:03:21 -0400
Date: Thu, 17 Apr 2008 15:02:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Possible mem leak in copy_process()
Message-ID: <20080417130252.GB6640@elte.hu>
References: <alpine.LNX.1.00.0804162336480.9837@dragon.funnycrock.com> <20080417115718.GC103@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417115718.GC103@tv-sign.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> > 1331 		if (likely(p->pid)) {

> > 1351 		}

> > Event leaked_storage: Returned without freeing storage "pid" Also 
> > see events: [alloc_fn][var_assign][pass_arg]
> 
> this looks like a false alarm.
> 
> p->pid == pid->numbers[0].nr. If "struct pid *pid" was allocated, its 
> .nr can't be 0.
> 
> IOW, !p->pid means that pid == init_struct_pid, it wasn't allocated 
> but was passed from the caller.

should we perhaps codify this rule via adding something like this to the 
else branch:

   WARN_ON_ONCE(task_pid(p) != &init_struct_pid);

?

	Ingo
