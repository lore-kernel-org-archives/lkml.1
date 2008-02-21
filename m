Return-Path: <linux-kernel-owner+w=401wt.eu-S1761766AbYBUIoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761766AbYBUIoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 03:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYBUIoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 03:44:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47676 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYBUIoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 03:44:12 -0500
Subject: Re: Make yield_task_fair more efficient
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peter@programming.kicks-ass.net>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47BD2A99.3010608@linux.vnet.ibm.com>
References: <20080221053321.GA26918@balbir.in.ibm.com>
	 <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com>
	 <20080221070733.GA13694@elte.hu>  <47BD2A99.3010608@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 09:43:59 +0100
Message-Id: <1203583439.6243.119.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 13:09 +0530, Balbir Singh wrote:

> sched_yield() is supported API

For SCHED_FIFO/SCHED_RR.

>  and also look at http://lkml.org/lkml/2007/9/19/351.

Read on (http://lkml.org/lkml/2007/9/19/371) and find:
        
        The sched_yield() behaviour is actually very well-defined for RT
        tasks (now, whether it's a good interface to use or not is still
        open to debate, but at least it's a _defined_ interface ;), and
        I think we should at least try to approximate that behaviour for
        normal tasks, even if they aren't RT.

sched_yield() just isn't a very useful API except in RT and even there
one can question it.

> I am trying to make sched_yield() efficient
> when compat_sched_yield is turned on (which is most likely), since people will
> want that behaviour (Hint, please read the man-page for sched_yield).

I did, so what? read the POSIX spec - its just plain undefined for
SCHED_OTHER. We already do something 'sensible' for those few broken
applications relying on unspecified behaviour.

> There are
> already several applications using sched_yield(), so they all suffer.

Who is using it, where is their source so we can show its faster to not
use it?

Really, hiding behind closed sores doesn't make it good.


