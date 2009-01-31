Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbZAaDbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbZAaDbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbZAaDa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:30:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47743 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbZAaDa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:30:58 -0500
Date: Sat, 31 Jan 2009 04:30:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>
Subject: Re: [patch 3/7] epoll keyed wakeups - introduce key-aware wakeup
	macros
Message-ID: <20090131033035.GA26640@elte.hu>
References: <send-serie.davidel@xmailserver.org.16376.1233372317.3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <send-serie.davidel@xmailserver.org.16376.1233372317.3>
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


* Davide Libenzi <davidel@xmailserver.org> wrote:

> +#define wake_up(x)			kwake_up(x, NULL)
> +#define wake_up_nr(x, nr)		kwake_up_nr(x, nr, NULL)
> +#define wake_up_all(x)			kwake_up_all(x, NULL)
> +#define wake_up_locked(x)		kwake_up_locked(x, NULL)
> +
> +#define wake_up_interruptible(x)	kwake_up_interruptible(x, NULL)
> +#define wake_up_interruptible_nr(x, nr)	kwake_up_interruptible_nr(x, nr, NULL)
> +#define wake_up_interruptible_all(x)	kwake_up_interruptible_all(x, NULL)
> +#define wake_up_interruptible_sync(x)	kwake_up_interruptible_sync(x, NULL)

i like the patchset - nice work!

One minor worry i have: these wakeup calls are _very_ common in the 
kernel, and this patch adds an extra parameter to it that is unused (NULL) 
in 99% of the cases.

Would be nice to see the kernel image size increase due to this change 
(which gives a good measure about how much of an issue this is).

If it's of any worrying level, it might make sense to keep the original 
functions untouched, and introduce a second entry point that has one more 
parameter. Ok?

	Ingo
