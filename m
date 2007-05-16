Return-Path: <linux-kernel-owner+w=401wt.eu-S934513AbXEPXnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934513AbXEPXnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760074AbXEPXnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:43:15 -0400
Received: from mail.screens.ru ([213.234.233.54]:36686 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759997AbXEPXnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:43:14 -0400
Date: Thu, 17 May 2007 03:43:20 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steve.Hawkes@motorola.com
Subject: Re: [PATCH] recalc_sigpending_tsk fixes
Message-ID: <20070516234320.GB2144@tv-sign.ru>
References: <7BFDACCD6948EF4D8FE8F4888A91596A01636E70@tx14exm60.ds.mot.com> <20070516200324.835BC1F8509@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516200324.835BC1F8509@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Roland McGrath wrote:
> 
> + * After recalculating TIF_SIGPENDING, we need to make sure the task wakes up.
> + * This is superfluous when called on current, the wakeup is a harmless no-op.
> + */
> +void recalc_sigpending_and_wake(struct task_struct *t)
> +{
> +	if (recalc_sigpending_tsk(t))
> +		signal_wake_up(t, 0);
>  }

We already discussed this, this is not so important, but how about

	void recalc_sigpending_and_wake(struct task_struct *t)
	{
		int was_pending = signal_pending(t);

		if (recalc_sigpending_tsk(t) && !was_pending)
			signal_wake_up(t, 0);
	}

?

This "was_pending" is more a documenation than a optimization.

Oleg.

