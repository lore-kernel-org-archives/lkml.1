Return-Path: <linux-kernel-owner+w=401wt.eu-S941338AbXHMTPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941338AbXHMTPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935386AbXHMTOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:14:14 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:56403 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765678AbXHMTOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:14:12 -0400
Date: Mon, 13 Aug 2007 23:14:07 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk-manpages@gmx.net>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 4/4] signalfd: make it group-wide, fix posix-timers scheduling
Message-ID: <20070813191407.GA816@tv-sign.ru>
References: <20070812170533.GA4305@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812170533.GA4305@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12, Oleg Nesterov wrote:
>
> Untested, user visible change.
> 
> With this patch any thread can dequeue its own private signals via signalfd,
> even if it was created by another sub-thread.
> 
> To do so, we pass "current" to dequeue_signal() if the caller is from the same
> thread group. This also fixes the scheduling of posix timers broken by the
> previous patch.
> 
> If the caller doesn't belong to this thread group, we can't handle __SI_TIMER
> case properly anyway. Perhaps we should forbid the cross-process signalfd usage
> and convert ctx->tsk to ctx->sighand.

Sorry, the patch is not complete. I forgot about signalfd_poll() and somehow I
forgot to actually tweak de_thread(). I'll send a new one tomorrow.

Something should be done for 2.6.23, imho.

Oleg.

