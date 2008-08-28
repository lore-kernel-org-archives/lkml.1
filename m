Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYH1Mxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYH1Mxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYH1Mxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:53:44 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58319 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbYH1Mxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:53:43 -0400
Date: Thu, 28 Aug 2008 16:58:32 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] exit signals: use of uninitialized field notify_count
Message-ID: <20080828125832.GA221@tv-sign.ru>
References: <alpine.DEB.1.00.0808261505550.15543@abydos.NerdBox.Net> <20080827080136.GA4453@elte.hu> <20080827161141.GA97@tv-sign.ru> <alpine.DEB.1.00.0808271747160.15543@abydos.NerdBox.Net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0808271747160.15543@abydos.NerdBox.Net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27, Steve VanDeBogart wrote:
>
> It looks like that would work.  Seems that
> sig->count == 0 && sig->group_exit_task != NULL can never be true.
> If it does work, a lot of initialization in copy_signal() can be
> removed and it would reduce the chances that a similar problem would be
> reintroduced.  I would submit a patch, but I'm not sure how to trigger
> those code paths in order to test it.

I'd suggest to make 2 patches. The first one adds "->notify_count = 0"
to copy_signal() and removes "->group_exit_task != NULL" checks. The
second one changes copy_signal() to use zalloc.

BTW, I forgot to mention that you can kill the "thread_group_leader()"
check in exit_notify() too.

Oleg.

