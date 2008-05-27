Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbYE0GZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbYE0GZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 02:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbYE0GZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 02:25:20 -0400
Received: from styx.suse.cz ([82.119.242.94]:41126 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755639AbYE0GZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 02:25:18 -0400
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a
	race
From: Petr Tesarik <ptesarik@suse.cz>
To: Roland McGrath <roland@redhat.com>
Cc: Luming Yu <luming.yu@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
In-Reply-To: <20080527061209.9A24426FAA6@magilla.localdomain>
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <3877989d0805220624i259a9d1j708795c65c636ca0@mail.gmail.com>
	 <20080522203428.835D626FA24@magilla.localdomain>
	 <3877989d0805222042p176da844k384ea512b1cfb0da@mail.gmail.com>
	 <20080523041940.39E8726FA24@magilla.localdomain>
	 <3877989d0805222224n77ce36b6wdf15c4bab330a0f8@mail.gmail.com>
	 <20080526001527.81E1126FA9E@magilla.localdomain>
	 <3877989d0805251830w70f19e4cu46fbc32148217749@mail.gmail.com>
	 <3877989d0805262031i29db16bcjfa31652afc746b49@mail.gmail.com>
	 <20080527040454.053C526FA9E@magilla.localdomain>
	 <3877989d0805262249yab130cbyfc5f5e54065cec5c@mail.gmail.com>
	 <20080527061209.9A24426FAA6@magilla.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: SuSE CR
Date: Tue, 27 May 2008 08:25:15 +0200
Message-Id: <1211869515.29836.2.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-05-26 at 23:12 -0700, Roland McGrath wrote:
> >  [<a00000010000a9f0>] skip_rbs_switch+0xe0/0x110
> >                                 sp=e000000141c9fe30 bsp=e000000141c90cf8
> >  [<a000000000010740>] __kernel_syscall_via_break+0x0/0x20
> >                                 sp=e000000141ca0000 bsp=e000000141c90cf8

Indeed, there seems to be a large hole here. So, this is either a bug in
the unwinder, or a bug in the RBS synchronization, which causes
corruption. My test machine currently needs some work to run 2.6.25
again, but I'll try your test case as soon as I re-install it later this
week.

Cheers,
Petr Tesarik

> >  [<a0000001000971c0>] ptrace_stop+0xa0/0x3e0
> >                                 sp=e00000014716fdb0 bsp=e000000147160ca8
> >  [<a000000100097650>] ptrace_notify+0x150/0x1c0
> >                                 sp=e00000014716fdb0 bsp=e000000147160c88
> 
> If this is a backtrace of a single thread on the same kernel stack, it has
> a stack depth of over 84MB.  You still need to follow the path inside
> ia64_ptrace_stop() to see how any of this is possible.
> 
> 
> Thanks,
> Roland
