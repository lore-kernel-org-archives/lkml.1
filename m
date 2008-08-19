Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYHSWee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYHSWee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYHSWeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:34:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:63266 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbYHSWeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:34:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,237,1217833200"; 
   d="scan'208";a="327524294"
From: "Luck, Tony" <tony.luck@intel.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Tue, 19 Aug 2008 15:34:18 -0700
Subject: RE: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Topic: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Thread-Index: AckCStkQ+6iApNTZRcS16nQYT57U0QAACXUg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA309E6FF01@orsmsx505.amr.corp.intel.com>
References: <20080804194646.GA17390@us.ibm.com>
 <57C9024A16AD2D4C97DC78E552063EA30844B26C@orsmsx505.amr.corp.intel.com>
 <20080813162553.GA5720@elte.hu> <20080813192909.GA31685@us.ibm.com>
 <57C9024A16AD2D4C97DC78E552063EA3084A65FD@orsmsx505.amr.corp.intel.com>
 <20080819221939.GC11599@us.ibm.com>
In-Reply-To: <20080819221939.GC11599@us.ibm.com>
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

> Yes, your patch in isolation (having reverted Peter's
> c1955a3d4762e7a9bf84035eb3c4886a900f0d15) allows this box to boot
> 2.6.27-rc3 with CONFIG_PRINTK_TIME=y. As you noted, I did see some
> oddities in the printk timings, where the values would go up then back
> down, but nothing further out of the ordinary.

Good.  Thanks a lot for testing.

> P.S. Should I start a separate thread on the messages I mentioned
> earlier (but only in passing)?
>
> [   32.593534] kernel unaligned access to 0xe000000644220466, ip=0xa000000100516fa1

Separate thread sounds like a good idea.  You should decode the
ip=value to which routine was running. Look at System.map to get
the routine name, or use "objdump -d" to disassamble your vmlinux
to find the exact instruction (but note that the kernel indicates
the instruction in the bundle with a low order digit of 0, 1, 2
whereas the objdump disassembly uses 0, 6, c).

-Tony
