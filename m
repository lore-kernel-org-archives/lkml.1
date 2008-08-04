Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbYHDWLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbYHDWLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 18:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757354AbYHDWKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 18:10:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:4017 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411AbYHDWKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 18:10:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,306,1215414000"; 
   d="scan'208";a="425925037"
From: "Luck, Tony" <tony.luck@intel.com>
To: David Miller <davem@davemloft.net>
CC: "nacc@us.ibm.com" <nacc@us.ibm.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 4 Aug 2008 15:10:40 -0700
Subject: RE: [BISECTION RESULT] sched: revert cpu_clock to
 pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Topic: [BISECTION RESULT] sched: revert cpu_clock to
 pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Index: Acj2feJleuX1QcPGTCGNrzIdwXeTDQAAC6KA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA308329139@orsmsx505.amr.corp.intel.com>
References: <20080804194646.GA17390@us.ibm.com>
	<57C9024A16AD2D4C97DC78E552063EA308328FB4@orsmsx505.amr.corp.intel.com>
	<57C9024A16AD2D4C97DC78E552063EA308329110@orsmsx505.amr.corp.intel.com>
 <20080804.150249.71509974.davem@davemloft.net>
In-Reply-To: <20080804.150249.71509974.davem@davemloft.net>
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

> Can you guys on IA64 possibly set ar.k3 simply to zero or to some
> other similar value which cancels out the per-cpu computation?
>
> That's what sparc64 and other platforms do.

In cpu_init() we set ar.k3 to the base physical address of the percpu
area.  The alt-dtlb miss handler uses this register to set up a
TLB mapping from virtual address 0xffffffffffff0000 to this physical
address.

This means that most per-cpu accesses are very cheap (as the compiler
can use a small -ve offset from register r0 to load the virtual
address).

Accessing ar.k3 is a bit slow ... so making the per-cpu code
use that on every access to a per-cpu variable would be unpleasant.

-Tony
