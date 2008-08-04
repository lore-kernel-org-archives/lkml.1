Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYHDQ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYHDQ20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYHDQ2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:28:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63889 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbYHDQ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:28:15 -0400
Date: Mon, 4 Aug 2008 12:28:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arnaldo Carvalho de Melo <acme@redhat.com>
cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC] ftrace: support tracing functions in one module
In-Reply-To: <20080804161506.GA17964@ghostprotocols.net>
Message-ID: <alpine.DEB.1.10.0808041225330.19776@gandalf.stny.rr.com>
References: <d82e647a0808030050n3b72d96dh91c0ac94eadc34f@mail.gmail.com> <alpine.DEB.1.10.0808031042440.30870@gandalf.stny.rr.com> <d82e647a0808031911j20cc9588o813bb15a46df1db4@mail.gmail.com> <20080804161506.GA17964@ghostprotocols.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 4 Aug 2008, Arnaldo Carvalho de Melo wrote:
> > 
> > Do you have the plan to support tracing functions in one module or in one kernel
> > address range?
> 
> What about using:
> 
> [acme@doppio pahole]$ nm --defined-only /usr/lib/debug/lib/modules/2.6.24.7-75.el5rt/kernel/drivers/net/tg3.ko.debug | grep ' t ' | cut -d' ' -f3 | head 
> __tg3_set_coalesce
> __tg3_set_mac_addr
> __tg3_set_rx_mode
> _tw32_flush
> tg3_5700_link_polarity
> tg3_abort_hw
> tg3_alloc_rx_skb
> tg3_ape_driver_state_change
> tg3_bmcr_reset
> tg3_change_mtu
> [acme@doppio pahole]$
> 
> Feed this to /sys/kernel/debug/tracing/set_ftrace_filter and you should
> be set, no?
> 
> Ok, you need to have the kernel-debuginfo package installed, and I guess
> we can get away with that, but for now, isn't that enough?


Or simply (again for tg3 :


# awk '/\[tg3\]/ { print $3 }' /proc/kallsyms  \
   > /debug/tracing/set_ftrace_filter

-- Steve

