Return-Path: <linux-kernel-owner+w=401wt.eu-S1760547AbYFSMnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760547AbYFSMnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbYFSMm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:42:57 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:45376 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755268AbYFSMm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:42:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar4EAKrqWUhMQW1O/2dsb2JhbACBWq49
Date: Thu, 19 Jun 2008 08:42:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH]: Sparc64 immediate values
Message-ID: <20080619124253.GA13433@Krystal>
References: <20080513.044011.204136790.davem@davemloft.net> <20080513123615.GA29334@Krystal> <20080513.152949.155579984.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080513.152949.155579984.davem@davemloft.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:41:57 up 14 days, 17:22,  2 users,  load average: 4.77, 2.35,
	1.32
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

I'm picking this patch up in my LTTng patchset for testing.

Thanks,

Mathieu

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date: Tue, 13 May 2008 08:36:15 -0400
> 
> > However, it does not protect from having a thread preempted in the
> > middle of this instruction sequence and therefore to see incoherent
> > values.
> 
> Yes, that makes such schemes unworkable, how hum...
> 
> > Are there non-maskable interrupts on sparc64 ?
> 
> Yes, and no.  When the PSTATE_IE bit is cleared in the
> processor state register, no interrupts whatsoever are
> recognized by the processor.  This is off only during
> trap entry/exit sequences, and some other special bits
> of code.
> 
> > The one thing we could do to allow such updates without using
> > stop_machine is to create something similar to the read seqlock using
> > immediate values.
> 
> Yes I saw such suggestions in the comments of the immediate code,
> you don't have to describe such things all over again.
> 
> Doing something so heavy like this in the "fast path" is completely
> pointless in my opinion.
> 
> Better to keep brainstorming on a scheme that works without adding any
> instructions to the immediate load sequence.  If you add instructions,
> fetching the instructions themselves become just as expensive, if not
> moreso, than the load we are eliminating.

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
