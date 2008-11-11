Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYKKVPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYKKVPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYKKVPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:15:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50912 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbYKKVPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:15:06 -0500
Date: Tue, 11 Nov 2008 21:13:06 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Nicolas Pitre <nico@cam.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, dhowells@redhat.com, mingo@elte.hu,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] convert cnt32_to_63 to inline
Message-ID: <20081111211306.GA12739@flint.arm.linux.org.uk>
Mail-Followup-To: Nicolas Pitre <nico@cam.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, dhowells@redhat.com, mingo@elte.hu,
	a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
	ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
	davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
	rostedt@goodmis.org, linux-arch@vger.kernel.org
References: <20081109162250.GB10181@Krystal> <alpine.LFD.2.00.0811092304300.13034@xanadu.home> <20081109204256.89ab7925.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101627510.13034@xanadu.home> <20081110135850.0d620f3c.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101811130.13034@xanadu.home> <20081110152221.64948d23.akpm@linux-foundation.org> <alpine.LFD.2.00.0811101917450.13034@xanadu.home> <20081111182759.GA8052@Krystal> <alpine.LFD.2.00.0811111543060.27509@xanadu.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811111543060.27509@xanadu.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2008 at 04:00:46PM -0500, Nicolas Pitre wrote:
> No thank you.  If this trend continues I'm going to make it back private 
> to ARM again so you could pessimize your own code as much as you want.

As I've already stated several days ago, I think that's the right
course of action.  Given all the concerns raised, it's clearly not
something that should have been allowed to become generic.

So, let's just close this discussion off by taking that course of
action.

What's required is (in order):
1. a local copy for NM10300 needs to be created and it converted to that
2. these two commits then need to be reverted:

bc173c5789e1fc6065fd378edc815914b40ee86b
b4f151ff899362fec952c45d166252c9912c041f

Then our usage is again limited to sched_clock() which is well understood
and known to be problem free.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
