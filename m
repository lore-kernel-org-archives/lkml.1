Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbYHDRVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbYHDRVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759408AbYHDRVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:21:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757380AbYHDRVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:21:14 -0400
Date: Mon, 4 Aug 2008 14:18:56 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC] ftrace: support tracing functions in one module
Message-ID: <20080804171856.GB17964@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <srostedt@redhat.com>
References: <d82e647a0808030050n3b72d96dh91c0ac94eadc34f@mail.gmail.com> <alpine.DEB.1.10.0808031042440.30870@gandalf.stny.rr.com> <d82e647a0808031911j20cc9588o813bb15a46df1db4@mail.gmail.com> <20080804161506.GA17964@ghostprotocols.net> <alpine.DEB.1.10.0808041225330.19776@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808041225330.19776@gandalf.stny.rr.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 04, 2008 at 12:28:12PM -0400, Steven Rostedt escreveu:
> 
> On Mon, 4 Aug 2008, Arnaldo Carvalho de Melo wrote:
> > > 
> > > Do you have the plan to support tracing functions in one module or in one kernel
> > > address range?
> > 
> > What about using:
> > 
> > [acme@doppio pahole]$ nm --defined-only /usr/lib/debug/lib/modules/2.6.24.7-75.el5rt/kernel/drivers/net/tg3.ko.debug | grep ' t ' | cut -d' ' -f3 | head 
> > __tg3_set_coalesce
> > __tg3_set_mac_addr
> > __tg3_set_rx_mode
> > _tw32_flush
> > tg3_5700_link_polarity
> > tg3_abort_hw
> > tg3_alloc_rx_skb
> > tg3_ape_driver_state_change
> > tg3_bmcr_reset
> > tg3_change_mtu
> > [acme@doppio pahole]$
> > 
> > Feed this to /sys/kernel/debug/tracing/set_ftrace_filter and you should
> > be set, no?
> > 
> > Ok, you need to have the kernel-debuginfo package installed, and I guess
> > we can get away with that, but for now, isn't that enough?
> 
> 
> Or simply (again for tg3 :
> 
> 
> # awk '/\[tg3\]/ { print $3 }' /proc/kallsyms  \
>    > /debug/tracing/set_ftrace_filter

For the drivers that do proper namespacing, yes, that should be enough
in most cases :)

- Arnaldo
