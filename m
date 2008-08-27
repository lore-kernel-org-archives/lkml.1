Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbYH0QHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbYH0QHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbYH0QGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:06:54 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58431 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422AbYH0QGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:06:53 -0400
Date: Wed, 27 Aug 2008 20:11:41 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] exit signals: use of uninitialized field notify_count
Message-ID: <20080827161141.GA97@tv-sign.ru>
References: <alpine.DEB.1.00.0808261505550.15543@abydos.NerdBox.Net> <20080827080136.GA4453@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827080136.GA4453@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, Ingo Molnar wrote:
> 
> * Steve VanDeBogart <vandebo-lkml@NerdBox.Net> wrote:
> 
> > task->signal->notify_count is only initialized if
> > task->signal->group_exit_task is not NULL.  Reorder a conditional so
> > that uninitialised memory is not used.  Found by Valgrind.
> >
> > Signed-off-by: Steve VanDeBogart <vandebo-lkml@nerdbox.net>
> 
> Applied the commit below to tip/core/urgent, thanks. Roland/Oleg, do you 
> concur with the fix?

Inho, very nice cleanup.

Minor comment. As Roland pointed out, it makes sense to initialize
the whole signal_struct explicitely, perhaps copy_signal() should
just use zalloc. In that case we don't need to check ->group_exit_task
at all, the same for __exit_signal().

Thanks Steve! and what do you think about the above?

Oleg.

