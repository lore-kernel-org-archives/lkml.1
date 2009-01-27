Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbZA0Apu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbZA0Apu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZA0Apk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:45:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36319 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbZA0Apj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:45:39 -0500
Date: Tue, 27 Jan 2009 01:41:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ed Swierk <eswierk@aristanetworks.com>, rml@tech9.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix BUG: using smp_processor_id() in preemptible code
	in print_fatal_signal()
Message-ID: <20090127004124.GA10632@redhat.com>
References: <1233010818.14510.11.camel@localhost.localdomain> <20090126231555.GB6556@elte.hu> <1233012811.14510.18.camel@localhost.localdomain> <20090126233732.GA23128@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126233732.GA23128@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27, Ingo Molnar wrote:
>
> * Ed Swierk <eswierk@aristanetworks.com> wrote:
>
> > Take 2:
> >
> > With print-fatal-signals=1 on a kernel with CONFIG_PREEMPT=y, sending an
> > unexpected signal to a process causes a BUG: using smp_processor_id() in
> > preemptible code.
> >
> > get_signal_to_deliver() releases the siglock before calling
> > print_fatal_signal(), which calls show_regs(), which calls
> > smp_processor_id(), which is not supposed to be called from a
> > preemptible thread.
> >
> > Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>
>
> applied to tip/core/urgent, thanks Ed!

Ed, Ingo, but isn't it better to just use raw_smp_processor_id() in
__show_regs() ? This is only debug info, the printed CPU doesn't
have the "exact" meaning.

And, without the comment, it is not easy to see why print_fatal_signal()
disables preeemption before show_regs().

Oleg.

