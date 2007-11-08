Return-Path: <linux-kernel-owner+w=401wt.eu-S1760076AbXKHAWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760076AbXKHAWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:22:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759928AbXKHAVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:21:46 -0500
Received: from waste.org ([66.93.16.53]:55655 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759912AbXKHAVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:21:45 -0500
Date: Wed, 7 Nov 2007 18:20:27 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marin Mitov <mitov@issp.bas.bg>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>
Subject: Re: is minimum udelay() not respected in preemptible SMP kernel-2.6.23?
Message-ID: <20071108002027.GV17536@waste.org>
References: <200711071921.52330.mitov@issp.bas.bg> <20071107123045.c6d4b855.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107123045.c6d4b855.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 12:30:45PM -0800, Andrew Morton wrote:
> Ow.  Yes, from my reading delay_tsc() can return early (or after
> heat-death-of-the-universe) if the TSCs are offset and if preemption
> migrates the calling task between CPUs.
> 
> I suppose a lameo fix would be to disable preemption in delay_tsc().

preempt_disable is lousy documentation here. This and other cases
(lots of per_cpu users, IIRC) actually want a migrate_disable() which
is a proper subset. We can simply implement migrate_disable() as
preempt_disable() for now and come back later and implement a proper
migrate_disable() that still allows preemption (and thus avoids the
latency).

-- 
Mathematics is the supreme nostalgia of our time.
