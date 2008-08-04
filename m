Return-Path: <linux-kernel-owner+w=401wt.eu-S1765081AbYHDWWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765081AbYHDWWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYHDWWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:22:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:45807 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbYHDWWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:22:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,306,1215414000"; 
   d="scan'208";a="604031310"
From: "Luck, Tony" <tony.luck@intel.com>
To: David Miller <davem@davemloft.net>
CC: "nacc@us.ibm.com" <nacc@us.ibm.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 4 Aug 2008 15:22:37 -0700
Subject: RE: [BISECTION RESULT] sched: revert cpu_clock to
 pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Topic: [BISECTION RESULT] sched: revert cpu_clock to
 pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Index: Acj2f43X5EAz2uuoS+KX2NteVqJVUQAADFaQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA308329161@orsmsx505.amr.corp.intel.com>
References: <57C9024A16AD2D4C97DC78E552063EA308329110@orsmsx505.amr.corp.intel.com>
	<20080804.150249.71509974.davem@davemloft.net>
	<57C9024A16AD2D4C97DC78E552063EA308329139@orsmsx505.amr.corp.intel.com>
 <20080804.151448.190011603.davem@davemloft.net>
In-Reply-To: <20080804.151448.190011603.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What I'm suggesting is to very early on set ar.k3 to something which
> makes accesses go through the __per_cpu image copy in the main kernel
> image.

I'm looking at that ... but it is a bit more complex.  We only have
a "__per_cpu" block in the kernel on uni-processor systems. For
larger systems we dynamically allocate, and we have two different
mechanisms to that (one for SMP and one for NUMA).

> You could even set up a dummy TLB mapping during this early boot
> period.

Also a plausible idea ... though I'm not sure which physical address
I'd point this mapping at given the above allocation techniques.
Some of the problem here is that the kernel makes printk() calls
before any architecture dependent C code gets run.

> Otherwise it's just cleverness that is unique to IA64 and is going to
> constantly run into issues like this.  An alternative is to implement
> your own sched_clock() et al. where you can adhere to whatever special
> rules your platform may have.

Sigh.  we used to have our own (added by akpm in 2005) until it
got deleted :-(

-Tony
