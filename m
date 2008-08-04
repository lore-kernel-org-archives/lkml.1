Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbYHDQSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbYHDQSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYHDQSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:18:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbYHDQSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:18:16 -0400
Date: Mon, 4 Aug 2008 13:15:06 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC] ftrace: support tracing functions in one module
Message-ID: <20080804161506.GA17964@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <srostedt@redhat.com>
References: <d82e647a0808030050n3b72d96dh91c0ac94eadc34f@mail.gmail.com> <alpine.DEB.1.10.0808031042440.30870@gandalf.stny.rr.com> <d82e647a0808031911j20cc9588o813bb15a46df1db4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0808031911j20cc9588o813bb15a46df1db4@mail.gmail.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 04, 2008 at 10:11:17AM +0800, Ming Lei escreveu:
> 2008/8/3 Steven Rostedt <rostedt@goodmis.org>:
> >
> > On Sun, 3 Aug 2008, Ming Lei wrote:
> >
> >> Hi,
> >>
> >> IMO, ftrace is a very good tools, which can monitor almost all
> >> functions calling
> >> in the running kernel. The traced result is very complete and intact.
> >> But it seems
> >> too large to grasp the interested content.  For example, one may only
> >> have interest in
> >> functions calling in usbcore.ko, but he must trace all the functions
> >> calling in the
> >> kernel, so the tracing result is too large to use it.
> >>
> >> Could you add the support of tracing functions in one module only to ftrace?
> >
> > Look at the set_ftrace_filter in ftrace.txt. You can pick and choose which
> > functions to trace.  All the functions that can be traced is in
> 
> It seems not ver easy to opearte to trace all functions in a module. You need to
> write all function names to set_ftrace_filter. Also some functions have
> same names in kernel and modules. This can lead to some messed trace result.
> 
> Do you have the plan to support tracing functions in one module or in one kernel
> address range?

What about using:

[acme@doppio pahole]$ nm --defined-only /usr/lib/debug/lib/modules/2.6.24.7-75.el5rt/kernel/drivers/net/tg3.ko.debug | grep ' t ' | cut -d' ' -f3 | head 
__tg3_set_coalesce
__tg3_set_mac_addr
__tg3_set_rx_mode
_tw32_flush
tg3_5700_link_polarity
tg3_abort_hw
tg3_alloc_rx_skb
tg3_ape_driver_state_change
tg3_bmcr_reset
tg3_change_mtu
[acme@doppio pahole]$

Feed this to /sys/kernel/debug/tracing/set_ftrace_filter and you should
be set, no?

Ok, you need to have the kernel-debuginfo package installed, and I guess
we can get away with that, but for now, isn't that enough?

- Arnaldo
