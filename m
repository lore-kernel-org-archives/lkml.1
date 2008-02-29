Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbYB2Mtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbYB2Mtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759442AbYB2Mt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:49:27 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:33865 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758649AbYB2MtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:49:25 -0500
Date: Fri, 29 Feb 2008 13:38:15 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: ego@in.ibm.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ted Tso <tytso@us.ibm.com>,
       dvhltc@us.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 4/6] Preempt-RCU: Implementation
In-Reply-To: <20080229045328.GA18687@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0802291330590.2723@scrub.home>
References: <20071213170348.GA25981@in.ibm.com> <20071213171658.GE25981@in.ibm.com>
 <200802290534.57040.zippel@linux-m68k.org> <20080229045328.GA18687@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, 28 Feb 2008, Paul E. McKenney wrote:

> > Why got this moved into init/Kconfig?
> 
> Because there are some arches that don't have kernel/Kconfig.preempt,
> its earlier home.  Therefore, putting it into kernel/Kconfig.preempt
> broke those arches' builds by supplying neither PREEMPT_RCU nor
> CLASSIC_RCU.
> 
> > Now it's somewhere in the root menu, not really belonging to anything.
> 
> Do you have a suggested location?
> 
> > Also why is this a choice? Are more RCU types planned?
> 
> I don't expect additional drop-in replacements for RCU, though people
> are certainly free to experiment if they wish.  It is a choice because
> this gives people a very clear idea of the two options and because
> it makes the implementation a bit cleaner.

I'd suggest to move PREEMPT_RCU back to Kconfig.preempt and if you really 
need the second symbol leave this behind (maybe with a comment):

config CLASSIC_RCU
	def_bool !PREEMPT_RCU

Once there are more options, we can still look for a better place...

Also could you please add a proper dependency to RCU_TRACE on PREEMPT_RCU, 
so that this condition isn't needed anymore:

ifeq ($(CONFIG_PREEMPT_RCU),y)
obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
endif

Thanks.

bye, Roman
