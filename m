Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbYFDUdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbYFDUdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYFDUdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:33:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35304 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbYFDUdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:33:43 -0400
Message-ID: <4846FC21.10304@firstfloor.org>
Date: Wed, 04 Jun 2008 22:33:37 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: maxk@qualcomm.com, ioe-lkml@rameria.de, sivanich@sgi.com,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       kernel@kolivas.org, dfults@sgi.com, devik@cdi.cz, dino@in.ibm.com,
       emmanuel.pacaud@univ-poitiers.fr, deweerdt@free.fr, mingo@elte.hu,
       colpatch@us.ibm.com, nickpiggin@yahoo.com.au, rostedt@goodmis.org,
       oleg@tv-sign.ru, paulmck@us.ibm.com, menage@google.com,
       rddunlap@osdl.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com>	<1212446707.6269.26.camel@lappy.programming.kicks-ass.net>	<48447C75.8040203@qualcomm.com>	<200806030156.00155.ioe-lkml@rameria.de>	<4844BB41.7000605@qualcomm.com>	<4845D825.6000403@qualcomm.com>	<20080603194148.56dfebe1.pj@sgi.com>	<48461ADA.8020303@qualcomm.com>	<877id5v1fg.fsf@basil.nowhere.org>	<20080604124126.0d281a99.pj@sgi.com>	<20080604200350.GL20824@one.firstfloor.org> <20080604151622.a50b984f.pj@sgi.com>
In-Reply-To: <20080604151622.a50b984f.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I was responding to a need you noticed to isolate memory nodes (such as
> from stray glibc pages placed by init or the shell running early
> scripts), not to the need to isolate CPUs:

Yes, but in practice (enough memory for bootup) isolating CPUs
is equivalent to isolating nodes. So isolcpus=... tended to work.

I occasionally recommended it to people because it was much easier
to explain than replacing init.

The perfect solution would be probably just fix it in init(8)
and make it parse some command line option that then sets up
the right cpusets.

But you asked for isolcpus=... use cases and I just wanted to describe
one.

> So perhaps it boils down to a question of which is easiest to do,
> the answer to which will vary depending on where you are in the food
> chain of distributions.  Here "easy" means least likely to break
> something else.  All these mechanisms are relatively trivial, until
> one has to deal with conflicting software packages, configurations and
> distributions, changing out from under oneself.

One solution would be to move isolcpus=/isonodes= into init(8) and make
sure it's always statically linked. But failing that keeping it in the
kernel is not too bad. It's certainly not a lot of code.

On the other hand if the kernel implemented a isolnodes=... it would
be possible to exclude those nodes from the interleaving the kernel
does at boot, which might be also beneficial and give slightly
more isolation.

-Andi
