Return-Path: <linux-kernel-owner+w=401wt.eu-S1759137AbXELVnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbXELVnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 17:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbXELVnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 17:43:03 -0400
Received: from mail.screens.ru ([213.234.233.54]:51212 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797AbXELVnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 17:43:02 -0400
Date: Sun, 13 May 2007 01:42:57 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] scalable rw_mutex
Message-ID: <20070512214257.GA389@tv-sign.ru>
References: <20070511131541.992688403@chello.nl> <20070511132321.895740140@chello.nl> <20070511093108.495feb70.akpm@linux-foundation.org> <Pine.LNX.4.64.0705111006470.32716@schroedinger.engr.sgi.com> <20070511110522.ed459635.akpm@linux-foundation.org> <p73odkpeusf.fsf@bingen.suse.de> <20070512181254.GA331@tv-sign.ru> <20070512192130.GA8833@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512192130.GA8833@one.firstfloor.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12, Andi Kleen wrote:
>
> > This also allows us to de-uglify workqueue.c a little bit, it uses
> > a home-grown cpu_populated_map.
> 
> It might be obsolete iff more and more architecture don't use NR_CPUS filled
> possible_map anymore (haven't checked them all to know if it's true or not)
> 
> If not there are a couple of more optimizations that can be done, e.g.
> in networking by converting more code to hotplug notifier.

As for workqueue.c, it is not an optimization. It is a documentation.
For example, if CPU-hotplug use freezer, we can just do

	s/cpu_populated_map/cpu_online_map/

workqueue.c has a hotplug notifier, but we can't migrate work_structs
currently in a race-free manner.

So I vote for your patch in any case.

Oleg.

