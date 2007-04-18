Return-Path: <linux-kernel-owner+w=401wt.eu-S1031313AbXDRC3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031313AbXDRC3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 22:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031317AbXDRC3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 22:29:50 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55015 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031313AbXDRC3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 22:29:49 -0400
Date: Wed, 18 Apr 2007 11:28:49 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH] sysctl_panic_on_oom broken
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704171438390.8082@schroedinger.engr.sgi.com>
References: <462515CC.1080107@redhat.com> <Pine.LNX.4.64.0704171438390.8082@schroedinger.engr.sgi.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070418104631.EE4A.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 17 Apr 2007, Larry Woodman wrote:
> 
> > out_of_memory() does not panic when sysctl_panic_on_oom is set
> > if constrained_alloc() does not return CONSTRAINT_NONE.  Instead,
> > out_of_memory() kills the current process whenever constrained_alloc()
> > returns either CONSTRAINT_MEMORY_POLICY or CONSTRAINT_CPUSET.
> > This patch fixes this problem:
> 
> It recreates the old problem that we OOM while we still have memory 
> in other parts of the system.

Hmm. User's expectation is failover of clustering ASAP by panic.
Even if free memory remain due to cpuset/mempolicy setting,
some people may want failover soon.

Of course some other people don't want panic if free memory remain.
I think it depends on user.

If panic_on_oom is 1, only panic if mempolicy/cpuset is not used.
And if panic_on_oom is 2, panic on all case.
This might be desirable.

Bye.


-- 
Yasunori Goto 


