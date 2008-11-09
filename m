Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYKINoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYKINoe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 08:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbYKINoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 08:44:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56399 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbYKINoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 08:44:20 -0500
Date: Sun, 9 Nov 2008 13:43:03 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Nicolas Pitre <nico@cam.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] clarify usage expectations for cnt32_to_63()
Message-ID: <20081109134303.GA10654@flint.arm.linux.org.uk>
Mail-Followup-To: Nicolas Pitre <nico@cam.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	lkml <linux-kernel@vger.kernel.org>,
	Ralf Baechle <ralf@linux-mips.org>, benh@kernel.crashing.org,
	paulus@samba.org, David Miller <davem@davemloft.net>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
References: <9405.1226101315@redhat.com> <20081108001555.GE18378@flint.arm.linux.org.uk> <alpine.LFD.2.00.0811080939180.13034@xanadu.home> <alpine.LFD.2.00.0811081746060.13034@xanadu.home> <20081109022549.GA18508@Krystal> <alpine.LFD.2.00.0811082143320.13034@xanadu.home> <alpine.LFD.2.00.0811082356090.13034@xanadu.home> <alpine.LFD.2.00.0811090015570.13034@xanadu.home> <20081109064855.GA23782@Krystal> <alpine.LFD.2.00.0811090827160.13034@xanadu.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811090827160.13034@xanadu.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 08:34:23AM -0500, Nicolas Pitre wrote:
> Do you really have such instances where multiple call sites are needed?  
> That sounds even more confusing to me than the current model.  Better 
> encapsulate the usage of this macro within some function which has a 
> stronger meaning, such as sched_clock(), and call _that_ from multiple 
> sites instead.

What if sched_clock() is inline and uses cnt32_to_63()?  I think that's
where the problem lies.  Better add a comment that it shouldn't be used
inside another inline function.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
