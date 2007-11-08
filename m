Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbXKHBZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbXKHBZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 20:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbXKHBZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 20:25:19 -0500
Received: from mx1.suse.de ([195.135.220.2]:40049 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbXKHBZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 20:25:17 -0500
From: Andi Kleen <ak@suse.de>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: is minimum udelay() not respected in preemptible SMP kernel-2.6.23?
Date: Thu, 8 Nov 2007 02:20:58 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>, Marin Mitov <mitov@issp.bas.bg>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
References: <200711071921.52330.mitov@issp.bas.bg> <200711080131.01243.ak@suse.de> <20071108010347.GP19691@waste.org>
In-Reply-To: <20071108010347.GP19691@waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711080220.59086.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> But I think we'd be best off stashing a single bit somewhere and
> checking it at migrate time (relatively infrequent) rather than
> copying and zeroing out a potentially enormous affinity mask every
> time we disable migration (often, and in fast paths). Perhaps adding
> TASK_PINNED to the task state flags would do it?

It would need to be a count to be able to nest it.

> > get_cpu() etc. could be changed to use this then too.
>
> Some users of get_cpu might be relying on it to avoid actual
> preemption. In other words, we should have introduced a
> migrate_disable() when we first discovered the preempt/per_cpu
> conflict.

Ok perhaps it would make sense to migrate it step by step :- 
define a replacement for get_cpu and migrate over as users are getting
audited and eventually deprecate old one.

-Andi
