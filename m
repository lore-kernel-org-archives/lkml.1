Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbZEGJ30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbZEGJ30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761793AbZEGJY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:24:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44349 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761769AbZEGJY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:24:57 -0400
Date: Thu, 7 May 2009 11:19:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] security: rename ptrace_may_access =>
	ptrace_access_check
Message-ID: <20090507091917.GA23110@redhat.com>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu> <20090506235349.GC3756@redhat.com> <20090507002133.02D05FC39E@magilla.sf.frob.com> <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com> <20090507083851.GA19133@elte.hu> <20090507084943.GB19133@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507084943.GB19133@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07, Ingo Molnar wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
> Subject: security: rename ptrace_may_access => ptrace_access_check
> From: Ingo Molnar <mingo@elte.hu>
>
> The ->ptrace_may_access() methods are named confusingly - the real 
> ptrace_may_access() returns a bool, while these security checks have 
> a retval convention.
> 
> Rename it to ptrace_access_check, to reduce the confusion factor.

Great. Now we can rename (and fix the callers of) ptrace.c:ptrace_may_access()
accordingly.

But,

> -static inline int security_ptrace_may_access(struct task_struct *child,
> +static inline int security_ptrace_access_check(struct task_struct *child,
>  					     unsigned int mode)

You seem to forgot to update the callers of this helper.

Oleg.

