Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbYLLIzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbYLLIzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 03:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbYLLIz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 03:55:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58046 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbYLLIzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 03:55:25 -0500
Date: Fri, 12 Dec 2008 09:54:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
Message-ID: <20081212085457.GB25106@elte.hu>
References: <20081211155230.GA4230@elte.hu> <12c511ca0812111111t2992dd2cw8b4d57ac57bd0700@mail.gmail.com> <20081211193439.GA25986@elte.hu> <1229070570.12883.14.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229070570.12883.14.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2008-12-11 at 20:34 +0100, Ingo Molnar wrote:
> 
> >  struct perf_counter_hw_event {
> >         s64                     type;
> > 
> >         u64                     irq_period;
> >         u32                     record_type;
> > 
> >         u32                     disabled     :  1, /* off by default */
> >                                 nmi          :  1, /* NMI sampling   */
> >                                 raw          :  1, /* raw event type */
> >                                 __reserved_1 : 29;
> > 
> >         u64                     __reserved_2;
> >  };
> > 
> > if the hw_event.raw bit is set to 1, then the hw_event.type is fully 
> > 'raw'. The default is for raw to be 0. So negative numbers can be used 
> > for sw events, positive numbers for hw events. Both can be extended 
> > gradually, without arbitrarily limits introduced.
> 
> On that, I still don't think its a good idea to use bitfields in an 
> ABI. The C std is just not strict enough on them, and I guess that is 
> the reason this would be the first such usage.

I dont feel strongly about this, we could certainly change it.

But these are system calls which have per platform bit order anyway - is 
it really an issue? I'd agree that it would be bad for any sort of 
persistent or otherwise cross-platform data such as filesystems, network 
protocol bits, etc.

We use bitfields in a couple of system calls ABIs already, for example in 
PPP:

if_ppp.h-/* For PPPIOCGL2TPSTATS */
if_ppp.h-struct pppol2tp_ioc_stats {
if_ppp.h-       __u16           tunnel_id;      /* redundant */
if_ppp.h-       __u16           session_id;     /* if zero, get tunnel stats */
if_ppp.h:       __u32           using_ipsec:1;  /* valid only for session_id == 

	Ingo
