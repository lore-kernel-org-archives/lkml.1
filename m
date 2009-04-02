Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZDBFJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZDBFJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 01:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbZDBFJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 01:09:28 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:55149 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZDBFJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 01:09:27 -0400
Date: Thu, 2 Apr 2009 10:39:19 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, venkatesh.pallipadi@intel.com, vatsa@linux.vnet.ibm.com,
       arjan@infradead.org, svaidy@linux.vnet.ibm.com,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v4 RFC PATCH 1/4] timers: Framework for identifying pinned
	timers
Message-ID: <20090402050919.GA8813@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090401113128.GA22478@linux.vnet.ibm.com> <20090401113258.GB22478@linux.vnet.ibm.com> <20090401114146.GS11935@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090401114146.GS11935@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2009-04-01 13:41:46]:

> On Wed, Apr 01, 2009 at 05:02:58PM +0530, Arun R Bharadwaj wrote:
> > * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-04-01 17:01:28]:
> > 
> > This patch creates a new framework for identifying cpu-pinned timers
> > and hrtimers.
> > 
> > 
> > This framework is needed because pinned timers are expected to fire on
> > the same CPU on which they are queued. So it is essential to identify
> > these and not migrate them, in case there are any.
> 
> How would that interact with add_timer_on()? You currently only
> support the current CPU, don't you?
> 
> e.g. the new tip x86 machine check polling code relies on add_timer_on
> staying on that CPU.
>

Pinned timers are directly related to add_timer_on().
So I assume that whatever timer is queued using add_timer_on() is
supposed to be a pinned timer.
Currently, we can stay on one CPU and still queue a pinned timer on
some other CPU. We can mark those timers as 'pinned' to that
particular CPU.

--arun

> -Andi
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.
