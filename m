Return-Path: <linux-kernel-owner+w=401wt.eu-S1754373AbYKGUz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbYKGUz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYKGUzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:55:37 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38927 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbYKGUze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:55:34 -0500
Date: Fri, 7 Nov 2008 12:55:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Nicolas Pitre <nico@cam.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-ID: <20081107205512.GH6917@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081107053349.861709786@polymtl.ca> <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com> <20081107170902.GD22134@Krystal> <alpine.DEB.1.10.0811071459130.3711@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811071459130.3711@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 03:08:12PM -0500, Steven Rostedt wrote:
> 
> On Fri, 7 Nov 2008, Mathieu Desnoyers wrote:
> > 
> > I want to make sure
> > 
> >   __m_cnt_hi
> >  is read before
> >   mmio cnt_lo read
> 
> Hmm, let me make sure I understand why there is no wmb.
> 
> Paul, can you verify this?
> 
> Mathieu, you do the following:
> 
>    read a
>    smp_rmb
>    reab b
>    if (test b)
>       write a
> 
> So the idea is that you must read b to test it. And since we must read a 
> before reading b we can see that we write a before either?
> 
> The question remains, can the write happen before either of the reads?
> 
> But since the read b is reading the hw clock, perhaps that just implies a
> wmb on the hardware side?

The hardware must do an equivalent of a wmb(), but this might well be
done in logic or firmware on the device itself.

							Thanx, Paul
