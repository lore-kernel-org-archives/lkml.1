Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbZKIQsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbZKIQsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZKIQsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:48:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbZKIQsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:48:10 -0500
Date: Mon, 9 Nov 2009 17:40:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Neil Horman <nhorman@tuxdriver.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, marcin.slusarz@gmail.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091109164053.GB5160@redhat.com>
References: <20091102152520.GG23776@elte.hu> <20091102175407.GE4075@hmsreliant.think-freely.org> <20091102185137.GA28803@elte.hu> <20091103002355.GB19891@localhost.localdomain> <20091104112632.GA9243@elte.hu> <20091105204843.GA2980@hmsreliant.think-freely.org> <20091106092600.GC22505@elte.hu> <4AF7D8C2.60807@gmail.com> <20091109090143.GB24020@elte.hu> <4AF83B9A.60702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF83B9A.60702@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09, Jiri Slaby wrote:
>
> +	ppid = find_get_pid(pid);
> +	if (!ppid)
> +		goto out;
> +
> +	tsk = get_pid_task(ppid, PIDTYPE_PID);
> +
> +	if (!tsk)
> +		goto out_put_pid;
> +
> +	if (resource >= RLIM_NLIMITS)
> +		goto out_put_all;
> +
> +	retval = -EBUSY;
> +	if (!lock_task_sighand(tsk, &flags))
>
> X task_lock below cannot nest inside sighand (according to Oleg)

Yes, this is deadlockable.

Also, I don't understand why wthis code get's both pid and task_struct().

And the "if (resource >= RLIM_NLIMITS)" check is racy afaics, see
http://marc.info/?l=linux-kernel&m=125200862124872

Oleg.

