Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbYFBFB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbYFBFB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 01:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbYFBFBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 01:01:48 -0400
Received: from mga06.intel.com ([134.134.136.21]:25884 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751225AbYFBFBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 01:01:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,576,1204531200"; 
   d="scan'208";a="389273640"
Subject: Re: [Bug #10638] sysbench+mysql(oltp, readonly) 30% regression
	with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080530094541.GA32508@elte.hu>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	 <7wuznNhcUqC.A.IMB.TtBMIB@albercik>
	 <1211131278.6463.7.camel@lappy.programming.kicks-ass.net>
	 <1211135856.6463.22.camel@lappy.programming.kicks-ass.net>
	 <1211160283.3177.134.camel@ymzhang> <1211176540.8292.3.camel@twins>
	 <1211179767.3177.166.camel@ymzhang>  <20080530094541.GA32508@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Jun 2008 12:57:37 +0800
Message-Id: <1212382657.3177.319.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-30 at 11:45 +0200, Ingo Molnar wrote:
> Yanmin,
> 
> could you please check whether the performance regressions you noticed 
> are now fixed in upstream -git? [make sure merge a7f75d3bed28 is 
> included]
> 
> i believe most of the regressions to 2.6.25 you found should be 
> addressed - if not, please let me know which one is still hurting.
Most regressions are fixed.

I tested the latest git tree on a couple of machines. Below results compare with
2.6.25 result except special comments.


1) ﻿sysbench+mysql(oltp, readonly) 30% regression with 2.6.26-rc1:
﻿http://bugzilla.kernel.org/show_bug.cgi?id=10638
It's fixed completely.

2) ﻿volanoMark regression with kernel 2.6.26-rc1:
﻿http://bugzilla.kernel.org/show_bug.cgi?id=10634
﻿It's fixed completely.

3) ﻿hackbench regression with 2.6.26-rc2 on tulsa machine:
﻿http://bugzilla.kernel.org/show_bug.cgi?id=10761
On 16-thread tulsa machine, hackbench result becomes 34 seconds. 2.6.26-rc2's
result is 40 seconds and 2.6.26-rc1's is 30 seconds. So there is much improvement.
On another Montvale machine(supporting multi-threading,
but I don't turn on it in BIOS), hackbench has the similiar behavior.

4) aim7 regression with 2.6.26-rc1:
With Linus's patch which was accepted into 2.6.26-rc2, most aim7 regression disappeared,
but about 6% regression on 16-core tigerton still existed. If just applying Linus' patch
against 2.6.26-rc1, all regression of aim7 disappeared. So there is something else changed
in 2.6.26-rc2.
I retested aim7 against the latest git tree and all aim7 regression disappeared.

5) Kbuild regression 3%~6% with 2.6.26-rc1:
I run kbuild in a loop of 25 or more. On some machines, the testing script drops page cache
at the begining of every loop, and doesn't drop caches on other machines. The second testing
method result is stable, but the first one's result isn't stable. The regression is about the second
method.
I didn't report it because bisect located 2 groups of patches.
With the latest git, I retested kbuild and all regression with the second method disappears.



