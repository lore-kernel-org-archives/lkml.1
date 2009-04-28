Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbZD1Mw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbZD1Mw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 08:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbZD1MwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 08:52:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45870 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148AbZD1MwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 08:52:17 -0400
Date: Tue, 28 Apr 2009 14:47:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] copy_process: remove the unneeded
	clear_tsk_thread_flag(TIF_SIGPENDING)
Message-ID: <20090428124730.GA17868@redhat.com>
References: <20090427194845.GA6245@redhat.com> <20090428023919.E2311FC3C6@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428023919.E2311FC3C6@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Roland McGrath wrote:
>
> Acked-by: Roland McGrath <roland@redhat.com>
>
> > The forked child can have TIF_SIGPENDING if it was copied from parent's
> > ti->flags. But this is harmless and actually almost never happens, because
> > copy_process() can't succeed if signal_pending() == T.
>
> When it does happen, it's actually improper to clear it.  In a CLONE_THREAD
> case, the pending signals might include shared_pending signals that the
> child too should take.  (Arguably there is no way to notice, since the
> parent thread will be racing to dequeue the same signals.)

Yes, sure. Now I see the changelog is not very clear.

I meant, it is possible that the parent has the false TIF_SIGPENDING which
is cleared later by recalc_sigpending(). In this case it is correct to do
clear_tsk_thread_flag(p, TIF_SIGPENDING), but this almost never happens.

Oleg.

