Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbYHDWmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbYHDWmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbYHDWmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:42:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:22577 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbYHDWl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:41:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,306,1215414000"; 
   d="scan'208";a="367847081"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Luck, Tony" <tony.luck@intel.com>, David Miller <davem@davemloft.net>
CC: "nacc@us.ibm.com" <nacc@us.ibm.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 4 Aug 2008 15:41:51 -0700
Subject: RE: [BISECTION RESULT] sched: revert cpu_clock to
 pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Topic: [BISECTION RESULT] sched: revert cpu_clock to
 pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Index: Acj2f43X5EAz2uuoS+KX2NteVqJVUQAADFaQAADKOYA=
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3083291B2@orsmsx505.amr.corp.intel.com>
References: <57C9024A16AD2D4C97DC78E552063EA308329110@orsmsx505.amr.corp.intel.com>
	<20080804.150249.71509974.davem@davemloft.net>
	<57C9024A16AD2D4C97DC78E552063EA308329139@orsmsx505.amr.corp.intel.com>
 <20080804.151448.190011603.davem@davemloft.net>
 <57C9024A16AD2D4C97DC78E552063EA308329161@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA308329161@orsmsx505.amr.corp.intel.com>
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

> I'm looking at that ... but it is a bit more complex.  We only have
> a "__per_cpu" block in the kernel on uni-processor systems. For
> larger systems we dynamically allocate, and we have two different
> mechanisms to that (one for SMP and one for NUMA).

Humm.  Perhaps I can always build in __per_cpu and use it for
cpu 0.  And then fix the assembly in head.S to point at that
for cpu 0.  For other cpus I's also need to pass the allocation
address of their per-cpu block to the early asm code so they
could set up ar.k3 too.

-Tony
