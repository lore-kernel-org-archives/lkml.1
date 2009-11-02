Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZKBPKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZKBPKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbZKBPKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:10:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44914 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbZKBPKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:10:46 -0500
Date: Mon, 2 Nov 2009 16:10:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Subject: Re: [PATCH 2/3] extend get/setrlimit to support setting rlimits
	external to a process (v7)
Message-ID: <20091102151032.GF23776@elte.hu>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20091001171538.GB2456@hmsreliant.think-freely.org> <20091012161342.GA32088@hmsreliant.think-freely.org> <20091012201304.GG32088@hmsreliant.think-freely.org> <20091020005214.GA8886@localhost.localdomain> <20091020005412.GC8886@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020005412.GC8886@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


two small comments:

this is a really dangerous pattern:

> +	if (!lock_task_sighand(tsk, &flags))
> +		goto out_put_all;
> +

as it's followed by:

> +	else {
> +		struct rlimit val;
> +
> +		task_lock(tsk->group_leader);
> +		val = current->signal->rlim[resource];
> +		task_unlock(tsk->group_leader);
> +		retval = copy_to_user(rlim, &val, sizeof(*rlim)) ? -EFAULT : 0;
> +	}

please turn that into the regular:

	if () {
		...
	} else {
		...
	}

pattern that is a lot harder to mess up later on.

> +	return retval;
> +}
> +
> +
>  #ifdef __ARCH_WANT_SYS_OLD_GETRLIMIT

one too many newlines?

	Ingo
