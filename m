Return-Path: <linux-kernel-owner+w=401wt.eu-S1761923AbYFDSIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761923AbYFDSIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761647AbYFDSHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:07:47 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:45066 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761637AbYFDSHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:07:46 -0400
Date: Wed, 4 Jun 2008 22:08:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] __down_common: use signal_pending_state()
Message-ID: <20080604180858.GB10295@tv-sign.ru>
References: <20080604170906.GA10276@tv-sign.ru> <20080604173633.GI3549@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604173633.GI3549@parisc-linux.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04, Matthew Wilcox wrote:
>
> On Wed, Jun 04, 2008 at 09:09:06PM +0400, Oleg Nesterov wrote:
> > Cleanup. __down_common() can use the new signal_pending_state() helper.
>
> This is a bad optimisation.  __down_common gets inlined and the constant
> 'state' versions are optimised away for the versions which don't apply.
>
> NAK this patch.

OK.

But this was not optimisation, just code re-use.

Actually, I don't understand why __down_common/__mutex_lock_common are inlines,
perhaps it is better to shrink .text instead.

For example, "size kernel/mutex.o" reports

	2715       0      12    2727     aa7 kernel/mutex.o

with __mutex_lock_common() uninlined, we have

	1565       0      12    1577     629 kernel/mutex.o

the difference is more than K.

Oleg.

