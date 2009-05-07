Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbZEGIko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbZEGIko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZEGIkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:40:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60324 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160AbZEGIkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:40:31 -0400
Date: Thu, 7 May 2009 10:38:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 3/3a] ptrace: add _ptrace_may_access()
Message-ID: <20090507083851.GA19133@elte.hu>
References: <20090505224729.GA965@redhat.com> <20090506080050.GF17457@elte.hu> <20090506235349.GC3756@redhat.com> <20090507002133.02D05FC39E@magilla.sf.frob.com> <20090507063606.GA15220@redhat.com> <20090507082027.GD12285@elte.hu> <20090507083102.GA20125@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507083102.GA20125@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 05/07, Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > /* the callers of ptrace_may_access should be fixed */
> > >
> > > 	int ptrace_may_access(struct task_struct *task, unsigned int mode)
> >
> > Sigh, NAK, for the reasons explained in the previous mails.
> 
> Agreed, but what about security_operations->ptrace_may_access ?
> 
> It has the same (bad) name, but returns the error code or 0 on 
> success.

Bad code should generally be fixed, or in exceptional circumstances 
it can tolerated if it's pre-existing bad code, but it should never 
be propagated. It has not spread _that_ widely yet, and is isolated 
to the security subsystem:

 include/linux/security.h
 security/capability.c
 security/commoncap.c
 security/root_plug.c
 security/security.c
 security/selinux/hooks.c
 security/smack/smack_lsm.c

	Ingo
