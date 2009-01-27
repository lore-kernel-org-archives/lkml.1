Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbZA0DIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbZA0DIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 22:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbZA0DIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 22:08:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59963 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbZA0DIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 22:08:20 -0500
Date: Tue, 27 Jan 2009 04:02:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ed Swierk <eswierk@aristanetworks.com>
Cc: Ingo Molnar <mingo@elte.hu>, rml@tech9.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix BUG: using smp_processor_id() in preemptible code
	in print_fatal_signal()
Message-ID: <20090127030237.GA14108@redhat.com>
References: <1233010818.14510.11.camel@localhost.localdomain> <20090126231555.GB6556@elte.hu> <1233012811.14510.18.camel@localhost.localdomain> <20090126233732.GA23128@elte.hu> <20090127004124.GA10632@redhat.com> <1233020040.14510.121.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233020040.14510.121.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Ed Swierk wrote:
>
> On Tue, 2009-01-27 at 01:41 +0100, Oleg Nesterov wrote:
> > Ed, Ingo, but isn't it better to just use raw_smp_processor_id() in
> > __show_regs() ? This is only debug info, the printed CPU doesn't
> > have the "exact" meaning.
>
> I guess it doesn't really matter which CPU the signal handling thread
> happened to be running on, but are there other situations where
> show_regs() is always expected to print the correct CPU (and if not, why
> bother printing the CPU at all)?  Disabling preemption here seems the
> safest approach and doesn't add much overhead.

OK.

> > And, without the comment, it is not easy to see why print_fatal_signal()
> > disables preeemption before show_regs().
>
> Agreed; here's an updated patch.

Actually, now I think show_regs() has other reasons to run with the
preemption disabled, __show_regs() does read_crX()/etc, I guess it is
better to stay on the same CPU throughout.

So, Ed, I am sorry for noise.

Oleg.

