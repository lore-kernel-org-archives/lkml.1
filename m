Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbZIPPeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbZIPPeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbZIPPeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:34:16 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:64212 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbZIPPeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:34:15 -0400
Subject: Re: RCU callbacks and TREE_PREEMPT_RCU
From: Catalin Marinas <catalin.marinas@arm.com>
To: paulmck@linux.vnet.ibm.com
Cc: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090916152929.GA6737@linux.vnet.ibm.com>
References: <1253110641.31751.92.camel@pc1117.cambridge.arm.com>
	 <20090916152929.GA6737@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 16 Sep 2009 16:34:15 +0100
Message-Id: <1253115255.31751.96.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Sep 2009 15:34:16.0564 (UTC) FILETIME=[268B9B40:01CA36E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 08:29 -0700, Paul E. McKenney wrote:
> On Wed, Sep 16, 2009 at 03:17:21PM +0100, Catalin Marinas wrote:
> > When TREE_PREEMPT_RCU is enabled, the rcu list traversing above fails
> > with access to 0x6b6b6b6b but it is fine with TREE_PREEMPT_RCU=n and
> > TREE_RCU=y. During clean-up, kmemleak objects should no longer be freed
> > by other means since kmemleak was disabled and all callbacks are
> > ignored. The system is a 900Mhz P3, 256MB RAM, CONFIG_SMP=n.
> > 
> > Is there something I'm doing wrong in kmemleak or a bug with RCU
> > preemption? The kernel oops looks like this:
> 
> From your description and the code above, I must suspect a bug with
> RCU preemption.  A new one, as the only bugs I am currently chasing
> involve NR_CPUS>32 (>64 on 64-bit systems).
> 
> CONFIG_SMP=n implies NR_CPUS==1 in your build, correct?

CONFIG_NR_CPUS=1.

-- 
Catalin

