Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbZKIRmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbZKIRmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZKIRmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:42:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbZKIRmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:42:39 -0500
Date: Mon, 9 Nov 2009 18:36:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091109173654.GA8809@redhat.com>
References: <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain> <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org> <20091106092600.GC22505@elte.hu> <4AF7D8C2.60807@gmail.com> <20091109090143.GB24020@elte.hu> <4AF83B9A.60702@gmail.com> <20091109164053.GB5160@redhat.com> <4AF84E2F.3010305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF84E2F.3010305@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09, Jiri Slaby wrote:
>
> On 11/09/2009 05:40 PM, Oleg Nesterov wrote:
> > Also, I don't understand why wthis code get's both pid and task_struct().
>
> And what do you suggest?

Well, I didn't see this patch, except the part quoted in your email...
(btw, thanks for ccing me).

We can call find_task_by_vpid() under rcu and do get_task_struct().
Or, given that we need tasklist anyway we can do find_task_by_vpid()
under tasklist and do not get() at all.

> > And the "if (resource >= RLIM_NLIMITS)" check is racy afaics, see
> > http://marc.info/?l=linux-kernel&m=125200862124872
>
> Your patch (which I have in my series btw) is likely needed for the
> setprlimit syscall, having this on my mind again from now on. But the
> 'if' above is a different story. 'resource' is an index here.

Yes, thanks, I misread this check ;)

> And as a bonus, what I found out now is that /proc/*/limits
> (proc_info_read->proc_pid_limits) doesn't necessarily reflect current
> limits. Since task_lock(current->group_leader) is not held, values of
> one limit may be from the old as well as the currently updated one.
>
> Am I right and do we care at all

I don't know, but personally I think we don't care.

Oleg.

