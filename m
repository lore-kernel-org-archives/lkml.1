Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbXJBH6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbXJBH6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbXJBH6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:58:38 -0400
Received: from www.tglx.de ([62.245.132.106]:55622 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbXJBH6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:58:38 -0400
Date: Tue, 2 Oct 2007 09:58:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mpm@selenic.com,
       "Huang, Ying" <ying.huang@intel.com>,
       Christoph Lameter <clameter@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
In-Reply-To: <20071002074635.GA31066@one.firstfloor.org>
Message-ID: <alpine.LFD.0.9999.0710020949220.3348@localhost.localdomain>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org> <p733awu6nva.fsf@bingen.suse.de> <20071001233225.88c67e8b.akpm@linux-foundation.org> <20071002073703.GA31108@elte.hu> <20071002074635.GA31066@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Andi Kleen wrote:
> On Tue, Oct 02, 2007 at 09:37:03AM +0200, Ingo Molnar wrote:
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On 02 Oct 2007 08:18:17 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> > >
> > > > The clockevents patches are not included in this; but given the 
> > > > recent trouble i'm not 100% sure they are even ready yet.
> > 
> > i'm curious, which "recent trouble" do you refer to? (The NMI watchdog 
> > bug [which is off by default] was fixed quickly. The C1E bug was found 
> > and fixed quickly. Anything else i missed?)
> 
> C1e and now the misrouted irq 0s Thomas reported.
> 
> Also i'm a little worried about the missing C1e check; it looks
> like it needs a re-review to make sure not other infrastructure was 
> missing.

I had completely forgotten about the C1E problem, which we debugged
half a year ago on 32bit. I went through the other pitfalls we had in
32bit carefully again and they are all covered on 64 bit too. C1E was
the only one I missed.

The irq0 problem is not a real one. The clock events code has no irq0 
bound to cpuX assumption at all. The only affected part is nmi_watchdog 
and I have a fix ready to handle this even for the irq#0 not on cpu#0 
case.

      tglx
