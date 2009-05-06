Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZEFHpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZEFHpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZEFHpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:45:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41043 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbZEFHpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:45:44 -0400
Date: Wed, 6 May 2009 09:44:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ptrace: cleanup check/set of PT_PTRACED during
	attach
Message-ID: <20090506074421.GE17457@elte.hu>
References: <20090505224727.GA958@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505224727.GA958@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> ptrace_attach() and ptrace_traceme() are the last functions which 
> look as if the untraced task can have task->ptrace != 0, this must 
> not be possible. Change the code to just check ->ptrace != 0 and 
> s/|=/=/ to set PT_PTRACED.
> 
> Also, a couple of trivial whitespace cleanups in ptrace_attach().
> 
> And move ptrace_traceme() up near ptrace_attach() to keep them 
> close to each other.

btw., while at it, please also fix the typos in 
include/linux/ptrace.h's PT_* flags section:

/*
 * Ptrace flags
 *
 * The owner ship rules for task->ptrace which holds the ptrace
 * flags is simple.  When a task is running it owns it's task->ptrace
 * flags.  When the a task is stopped the ptracer owns task->ptrace.
 */

s/owner ship/ownership
s/it's/its

Thanks,

	Ingo
