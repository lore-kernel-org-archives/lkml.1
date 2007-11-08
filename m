Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbXKHJLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbXKHJLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 04:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbXKHJLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 04:11:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60065 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112AbXKHJLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:11:32 -0500
Subject: Re: is minimum udelay() not respected in preemptible SMP
	kernel-2.6.23?
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Marin Mitov <mitov@issp.bas.bg>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>
In-Reply-To: <20071108002027.GV17536@waste.org>
References: <200711071921.52330.mitov@issp.bas.bg>
	 <20071107123045.c6d4b855.akpm@linux-foundation.org>
	 <20071108002027.GV17536@waste.org>
Content-Type: text/plain
Date: Thu, 08 Nov 2007 10:11:21 +0100
Message-Id: <1194513081.6289.130.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-07 at 18:20 -0600, Matt Mackall wrote:

>  This and other cases
> (lots of per_cpu users, IIRC) actually want a migrate_disable() which
> is a proper subset. 

The disadvantage of migrate_disable() is that it complicates the
load-balancer but more importantly, that it does bring a form of
latencies with it that are hard to measure. Using preempt_disable() for
these current per-cpu users basically forces them to keep it short.

   Which is a GOOD (tm) thing.

If we go overboard with this migrate_disable() stuff we can end up with
a very hard to analyse system that sporadically does weird stuff.

So, please, don't start that again.

Also see:
http://lkml.org/lkml/2007/7/23/338

