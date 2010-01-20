Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301Ab0ATT6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0ATT6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268Ab0ATT6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:58:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41911 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab0ATT6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:58:32 -0500
Date: Wed, 20 Jan 2010 20:58:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jim Keniston <jkenisto@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, ananth@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100120195826.GB24355@basil.fritz.box>
References: <4B545146.3080001@redhat.com> <20100118124419.GC1628@linux.vnet.ibm.com> <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com> <4B5459CA.9060603@redhat.com> <4B545ACF.40203@cs.helsinki.fi> <1263852957.2266.38.camel@localhost.localdomain> <4B556855.6040800@redhat.com> <1263923265.4998.28.camel@localhost.localdomain> <87wrzc39ww.fsf@basil.nowhere.org> <1264016052.5122.40.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264016052.5122.40.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Re: rewriting instructions that use rip-relative addressing.  We do that
> now.  See handle_riprel_insn() in patch #2.  (As far as we can tell, it
> works, but we'd appreciate your review of it.)

Yes, but how do you get within 2GB of it? Add lots of holes
in the address space? 

> The instruction decoder is used only during instruction analysis, while
> registering the probe -- i.e., in kernel space.

Registering the user probe? That means if there's a buffer overflow
in there it would be exploitable.

> > 
> > In general the trend has been also to make traps faster in the CPU, make 
> > sure you're not optimizing for some old CPU here.
> 
> I won't argue with that.  What Avi seems to be proposing buys us a
> speedup, but at the cost of increased complexity -- among other things,
> splitting the instrumentation code between user space (in the "XOL" area
> -- which would then be used for much more than XOL instruction slots)

You can't have a single XOL area, at least not if you want to support
shared libraries on 64bit & rip relative.

> and kernel space.  The splitting would presumably be handled by
> higher-level code -- SystemTap, perf, or whatever.  It's a neat idea,
> but it seems like a v2 kind of feature.

I'm not sure it can even work, unless you severly limited the allowed
instructions.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
