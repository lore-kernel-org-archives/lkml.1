Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbZBYENT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbZBYENT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbZBYENE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:13:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:47622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821AbZBYEND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:13:03 -0500
Date: Wed, 25 Feb 2009 05:12:59 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, vegard.nossum@gmail.com, mingo@elte.hu,
       stable@kernel.org, akpm@linux-foundation.org, penberg@cs.helsinki.fi
Subject: Re: [PATCH] v3 Teach RCU that idle task is not quiscent state at boot
Message-ID: <20090225041259.GA14149@wotan.suse.de>
References: <20090223161611.GA9563@linux.vnet.ibm.com> <20090223204332.GA19861@linux.vnet.ibm.com> <20090225002937.GA23733@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225002937.GA23733@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks OK to me. It's a bit "theoretically" displeasing that
you still treat synchronize_rcu as a gp even after we spawn
some kernel threads.

... but it probably isn't worth trying to rearrange the boot
code just to make this look better. I can't see any actual
problems that could arise, as the threads should not have
had a chance to run yet.

I wonder if you couldn't put in a WARN_ON(nr_context_switches() > 0)
in rcu_idle_now_means_idle() just in case?

On Tue, Feb 24, 2009 at 04:29:37PM -0800, Paul E. McKenney wrote:
> This patch fixes a bug located by Vegard Nossum with the aid of
> kmemcheck, updated based on review comments from Nick Piggin,
> Ingo Molnar, and Andrew Morton.
