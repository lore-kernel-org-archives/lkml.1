Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbYGZMiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbYGZMiu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 08:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755458AbYGZMil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 08:38:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55148 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbYGZMik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 08:38:40 -0400
Date: Sat, 26 Jul 2008 14:38:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hugh Dickins <hugh@veritas.com>, Jack Steiner <steiner@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] x86_64: Optimize percpu accesses
Message-ID: <20080726123819.GC20713@elte.hu>
References: <20080725211117.586723000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725211117.586723000@polaris-admin.engr.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> This patchset provides the following:
> 
>   * x86_64: Cleanup setup_percpu by fixing some minor potential
>     problems as well as add some debugging aids.
> 
>   * x86_64: Rebase per cpu variables to zero
> 
>     Rebase per cpu variables to zero in preparation for the following
>     patch to fold the pda into the per cpu area.
> 
>   * x86_64: Fold pda into per cpu area
> 
>     Declare the pda as a per cpu variable. This will allow the per cpu
>     variables to be accessible on the x86_64 using %gs as the base of
>     the percpu areas for each cpu:
> 
> 	%gs:per_cpu_xxxx
> 
>   * x86_64: Reference zero-based percpu variables offset from gs
> 
>     Actually implement the above operation for __get_cpu_var() and
>     __put_cpu_var().  Since this is now a single instruction, we
>     can remove the non-preemptible versions of x86_read_percpu()
>     and x86_write_percpu().
> 
> Note that the following changes are NOT in this patchset as the plan now
> seems to be that the common (to x86) variables that are in the pda should
> be made individual per cpu variables, leaving only the stack canary in place.
> 
>   * x86_64: Replace cpu_pda ops with percpu ops
>   * x86_64: Replace xxx_pda() operations with x86_xxx_percpu().
>   * x86_64: Remove xxx_pda() operations
>   * x86_64: Remove cpu_pda() macro
> 
> Based on linux-2.6.tip/master.

i've added these patches to tip/x86/percpu-zerobased, but not yet merged 
into tip/master. I've made it -git based - does this patchset have any 
functional dependencies on other patches?

	Ingo
