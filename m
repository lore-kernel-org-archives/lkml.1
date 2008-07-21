Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbYGUPgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbYGUPgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYGUPga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:36:30 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:55250 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbYGUPg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:36:29 -0400
Date: Mon, 21 Jul 2008 19:40:06 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: do_schedule_next_timer && si_overrun (Was: [PATCH] posix-timers: Do not modify an already queued timer signal)
Message-ID: <20080721154006.GB182@tv-sign.ru>
References: <1216219846-663-1-git-send-email-markmc@redhat.com> <20080716162131.GA1785@tv-sign.ru> <1216292911.28332.12.camel@muff> <20080717135556.GA770@tv-sign.ru> <1216377558.12300.13.camel@muff> <20080719163734.GA389@tv-sign.ru> <20080720065240.B3D3715421D@magilla.localdomain> <20080720110856.GC143@tv-sign.ru> <20080721004722.5869515421D@magilla.localdomain> <20080721152352.GA182@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721152352.GA182@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21, Oleg Nesterov wrote:
>
> On 07/20, Roland McGrath wrote:
> >
> > You do need to clear si_overrun there to be correct in the usual case
> > (not already queued).
>
> Indeed, I missed that. Can't we do this in send_sigqueue() ?

The more I look at the code, the more I'm getting confused...

Suppose that posix_timer_event()->send_sigqueue() increments info.si_overrun.
But (in general) it is not reported to the user-space, do_schedule_next_timer()
does:

	info->si_overrun = timr->it_overrun_last;

shouldn't it do

	info->si_overrun += timr->it_overrun_last;

instead?

Oleg.

