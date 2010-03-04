Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab0CDM6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 07:58:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab0CDM6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 07:58:43 -0500
Date: Thu, 4 Mar 2010 09:58:06 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, eranian@google.com,
       peterz@infradead.org, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com
Subject: Re: [RFC][PATCH 07/11] perf: Provide PERF_SAMPLE_REGS
Message-ID: <20100304125806.GB16539@ghostprotocols.net>
References: <bd4cb8901003030930q4050d074k11a45c3583b96502@mail.gmail.com>
 <1267637995.25158.96.camel@laptop>
 <bd4cb8901003030949v3db2db41o9cc1a65d53c370@mail.gmail.com>
 <20100303.095553.105186917.davem@davemloft.net>
 <20100304025908.GC23633@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100304025908.GC23633@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 04, 2010 at 03:59:08AM +0100, Ingo Molnar escreveu:
> 
> * David Miller <davem@davemloft.net> wrote:
> 
> > And more generally aren't we supposed to be able to eventually analyze perf 
> > dumps on any platform not just the one 'perf' was built under?
> 
> A aidenote: in this cycle Arnaldo improved this aspect of perf (and those 
> changes are now upstream). In theory you should be able to do a 'perf record' 
> + 'perf archive' on your Sparc box and then analyze it via 'perf report' on an 
> x86 box - and vice versa.
> 
> ( Note, it was not tested in that specific combination - another combination
>   was tested by Arnaldo: 32-bit PA-RISC profile interpreted on 64-bit x86. )

It was the other way around, 64-bit x86 interpreted on 64-bit PARISC.
Should work in any direction.

Caveats:

perf archive requires build-ids, the kernel has them in distros that
have this support in their toolchain, enabled unconditionally since
about 2.6.24.

If vmlinux is available, it will be used, if not a copy of
/proc/kallsyms is made and as well is keyed by build-id.

I have plans to cope with build-id-less systems, but no code yet.
 
- Arnaldo
