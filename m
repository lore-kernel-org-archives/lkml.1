Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbZDQNZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbZDQNZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbZDQNZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:25:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40529 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274AbZDQNZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:25:49 -0400
Date: Fri, 17 Apr 2009 15:28:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] [0/28] x86: MCE: Feature series for 2.6.31
Message-ID: <20090417132854.GO14687@one.firstfloor.org>
References: <20090407507.636692542@firstfloor.org> <49E866F2.7020407@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E866F2.7020407@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 08:24:34PM +0900, Hidetoshi Seto wrote:
> Andi Kleen wrote:
> > Various new Intel x86 machine check features, including initial support
> > for machine check recovery and new status bits. The actual machine check
> > recovery requires some generic VM changes, which will be posted in a separate
> > series ("POISON series") This series can be applied without the POISON
> > series and POISON requires these patches.
> > 
> > Especially the broadcast and early nowayout patches are fairly important for 
> > Nehalem CPUs, without them machine checks are often incorrectly reported
> > due to the shared bank topology of the system.
> > 
> > -Andi
> 
> Andi, could you divide this series into "cleanups" and "features"?

There is very little classic cleanup (as in make code prettier
to read and do nothing else) in this series, it's pretty much all features or 
feature like fixes. 

The ones that could be seen as cleanups are:

x86: MCE: Remove unused mce_events variable
x86: MCE: Use symbolic macros to access MCG_CAP register
x86: MCE: Remove mce_init unused argument
x86: MCE: Rename and align out2 label

That one is technically a cleanup, but I would argue it's a fix because
it shrinks code size:

x86: MCE: Use extended sysattrs for the check_interval attribute.

That one could be see as cleanup too although I personally consider removing
BKL feature too:

x86: MCE: Drop BKL in mce_open

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
