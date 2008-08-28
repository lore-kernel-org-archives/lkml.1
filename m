Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYH1A6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYH1A6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYH1A6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:58:24 -0400
Received: from abydos.nerdbox.net ([216.151.149.55]:43232 "EHLO
	abydos.NerdBox.Net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbYH1A6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:58:23 -0400
Date: Wed, 27 Aug 2008 17:58:17 -0700 (PDT)
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] exit signals: use of uninitialized field notify_count
In-Reply-To: <20080827161141.GA97@tv-sign.ru>
Message-ID: <alpine.DEB.1.00.0808271747160.15543@abydos.NerdBox.Net>
References: <alpine.DEB.1.00.0808261505550.15543@abydos.NerdBox.Net> <20080827080136.GA4453@elte.hu> <20080827161141.GA97@tv-sign.ru>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Oleg Nesterov wrote:

>> * Steve VanDeBogart <vandebo-lkml@NerdBox.Net> wrote:
>>
>>> task->signal->notify_count is only initialized if
>>> task->signal->group_exit_task is not NULL.  Reorder a conditional so
>>> that uninitialised memory is not used.  Found by Valgrind.
>
> Minor comment. As Roland pointed out, it makes sense to initialize
> the whole signal_struct explicitely, perhaps copy_signal() should
> just use zalloc. In that case we don't need to check ->group_exit_task
> at all, the same for __exit_signal().
>
> Thanks Steve! and what do you think about the above?

It looks like that would work.  Seems that
sig->count == 0 && sig->group_exit_task != NULL can never be true.
If it does work, a lot of initialization in copy_signal() can be
removed and it would reduce the chances that a similar problem would be
reintroduced.  I would submit a patch, but I'm not sure how to trigger
those code paths in order to test it.

--
Steve
