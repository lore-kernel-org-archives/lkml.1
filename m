Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbYFDUQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbYFDUQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYFDUQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:16:35 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47755 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751370AbYFDUQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:16:34 -0400
Date: Wed, 4 Jun 2008 15:16:22 -0500
From: Paul Jackson <pj@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: andi@firstfloor.org, maxk@qualcomm.com, ioe-lkml@rameria.de,
       sivanich@sgi.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       kernel@kolivas.org, dfults@sgi.com, devik@cdi.cz, dino@in.ibm.com,
       emmanuel.pacaud@univ-poitiers.fr, deweerdt@free.fr, mingo@elte.hu,
       colpatch@us.ibm.com, nickpiggin@yahoo.com.au, rostedt@goodmis.org,
       oleg@tv-sign.ru, paulmck@us.ibm.com, menage@google.com,
       rddunlap@osdl.org, suresh.b.siddha@intel.com, tglx@linutronix.de
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
Message-Id: <20080604151622.a50b984f.pj@sgi.com>
In-Reply-To: <20080604200350.GL20824@one.firstfloor.org>
References: <20080601213019.14ea8ef8.pj@sgi.com>
	<1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
	<48447C75.8040203@qualcomm.com>
	<200806030156.00155.ioe-lkml@rameria.de>
	<4844BB41.7000605@qualcomm.com>
	<4845D825.6000403@qualcomm.com>
	<20080603194148.56dfebe1.pj@sgi.com>
	<48461ADA.8020303@qualcomm.com>
	<877id5v1fg.fsf@basil.nowhere.org>
	<20080604124126.0d281a99.pj@sgi.com>
	<20080604200350.GL20824@one.firstfloor.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pj wrote:
> We (SGI) routinely handle that need with a custom init program,
> invoked with the init= parameter to the booting kernel, ...

Andi replied:
> There are no additional changes needed, but you must admit that isolcpus
> is a much more elegant solutation for this problem than hijacking init.

While I cannot claim that hijacking init is elegant, our gentle
readers are at risk of losing the context here.

I was responding to a need you noticed to isolate memory nodes (such as
from stray glibc pages placed by init or the shell running early
scripts), not to the need to isolate CPUs:

Andi had written earlier:
> One example I've seen in the past is that someone wanted to isolate a node
> completely from any memory traffic to avoid performance disturbance
> for memory intensive workloads.

Granted, this might be a distinction without a difference, because on
the very lightly loaded system seen at boot, local node memory placement
will pretty much guarantee that the memory is placed on the nodes next
to the CPUs on which init or its inelegant replacements are run.

You noted this yourself, when you wrote:
> Given the use case wants more a "isolnodes", but given that there
> tends to be enough free memory at boot "isolcpus" tended to work.

So perhaps it boils down to a question of which is easiest to do,
the answer to which will vary depending on where you are in the food
chain of distributions.  Here "easy" means least likely to break
something else.  All these mechanisms are relatively trivial, until
one has to deal with conflicting software packages, configurations and
distributions, changing out from under oneself.

That is, it can be desirable to have multiple mechanisms, so that the
various folks independently needing to manipulate such placement can
minimize stepping on each others feet.  By using the rarely hacked init=
mechanism for SGI software addons, we don't interfere with those who
are using the more common isolcpus= mechanism for such purposes as
offlining a bad CPU.

In sum, I suspect we agree that we have enough mechanisms, and don't
need an isolnodes as well.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
