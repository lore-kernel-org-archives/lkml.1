Return-Path: <linux-kernel-owner+w=401wt.eu-S1758848AbZAGPAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbZAGPAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 10:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754814AbZAGPAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 10:00:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33268 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbZAGPAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 10:00:35 -0500
Date: Wed, 7 Jan 2009 16:00:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Casey Dahlin <cdahlin@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20090107150025.GC23455@elte.hu>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <4964A888.3070400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4964A888.3070400@redhat.com>
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


* Casey Dahlin <cdahlin@redhat.com> wrote:

> >> +asmlinkage long sys_waitfd(int which, pid_t upid, int options, int unused)
> >> +{
> >> +	int ufd;
> >> +	struct waitfd_ctx *ctx;
> >> +
> >> +	/* Just to make sure we don't end up with a sys_waitfd4 */
> >> +	(void)unused;
> > 
> > looks a bit silly ...
> 
> 
> Do you mean the principle of having an unused argument around for future 
> use or the cast to void? The cast to void is there to suppress the 
> "Waning: unused argument" messages and make gcc happy.

gcc will not warn about unused function arguments - only about unused 
local variables. The 'unused' argument should either be removed 
altogether, or replaced with a properly named parameter and a check 
returning -ENOSYS if the argument is not zero (or something like that). 

(It's generally better to keep such syscalls extensible via such trivial 
means, if there's a remote chance for ever needing to extend that 
syscall.)

	Ingo
