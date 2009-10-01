Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZJAJW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZJAJW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbZJAJW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:22:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44600 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbZJAJW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:22:28 -0400
Date: Thu, 1 Oct 2009 11:22:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anirban Sinha <ASinha@zeugmasystems.com>, Darren Hart <dvhltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: futex question
Message-ID: <20091001092218.GH15345@elte.hu>
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2104]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed more futex folks.)

* Anirban Sinha <ASinha@zeugmasystems.com> wrote:

> Hi Folks:
> 
> We are observing something interesting regarding how task->robust_list
> pointer is being handled across a sys_execve() call. If a task does a
> sys_set_robust_list() with a certain head pointer and then at some point
> does a execve() call to over-write it's address space, the 'robust-list'
> pointer is never cleared. So in essence what happens is that during task
> exit, within mm_release(), the 
> if (unlikely(tsk->robust_list)) condition might still be true because
> the pointer has a non-null address. However, the actual address value
> may not belong to the new address space or point to something else
> within the new address space. Should we not just clear the pointer (and
> it's compat version) within do_execve()?
> 
> Granted, within exit_robust_list(), the fetch_robust_entry() calls will
> fail and bail out of the function. So in essence, nothing bad should
> happen. However, that extra code should save us from entering
> exit_robust_list() in the first place.
> 
> CCing Ingo since the robust futex support was started by him.
> 
> Cheers,
> 
> Ani
>  
