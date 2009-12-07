Return-Path: <linux-kernel-owner+w=401wt.eu-S935098AbZLGNos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935098AbZLGNos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935089AbZLGNor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:44:47 -0500
Received: from relay3.sgi.com ([192.48.152.1]:39059 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934963AbZLGNoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:44:44 -0500
Date: Mon, 7 Dec 2009 07:44:48 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
Message-ID: <20091207134448.GB1005@sgi.com>
References: <20091125074033.4c46c1b0@infradead.org> <20091203165004.GA14665@sgi.com> <Pine.WNT.4.64.0912030851500.13880@ppwaskie-MOBL2.amr.corp.intel.com> <20091203170149.GA15151@sgi.com> <Pine.WNT.4.64.0912030905530.16084@ppwaskie-MOBL2.amr.corp.intel.com> <20091203171946.GC15151@sgi.com> <Pine.WNT.4.64.0912031048590.8104@ppwaskie-MOBL2.amr.corp.intel.com> <20091204164227.GA28378@sgi.com> <1259961477.23199.39.camel@localhost> <m1eina9vw1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1eina9vw1.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 03:12:14PM -0800, Eric W. Biederman wrote:
> Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com> writes:
> 
> >> > > As a matter of fact, driver's allocating rings, buffers, queues on other nodes should optimally be made aware of the restriction.
> >> > 
> >> > The idea is that the driver will do its memory allocations for everything 
> >> > across nodes.  When it does that, it will use the kernel interface 
> >> > (function call) to set the corresponding mask it wants for those queue 
> >> > resources.  That is my end-goal for this code.
> >> > 
> >> 
> >> OK, but we will eventually have to reject any irqbalance attempts to send irqs to restricted nodes.
> >
> > See above.
> 
> Either I am parsing this conversation wrong or there is a strong
> reality distortion field in place.  It appears you are asking that we
> depend on a user space application to not attempt the physically
> impossible, when we could just as easily ignore or report -EINVAL to.
> 
> We really have two separate problems hear.
> - How to avoid the impossible.

The kernel does need to restrict attempts at the impossible.  However I see
nothing wrong with providing apps with information as to what the impossible
actually is.

> - How to deal with NUMA affinity.
