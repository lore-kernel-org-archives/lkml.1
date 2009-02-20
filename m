Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbZBTP4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbZBTP4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZBTP4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:56:30 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41818 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbZBTP43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:56:29 -0500
Date: Fri, 20 Feb 2009 07:56:27 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090220155626.GA8404@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090220134121.GA19575@damson.getinternet.no> <20090220135000.GA9616@elte.hu> <20090220140157.GA12799@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220140157.GA12799@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 03:01:57PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > ah, indeed:
> > 
> >         list_del_rcu(&va->list);
> > 
> > i suspect it could be hit big time in a workload that opens 
> > more than 512 files, as expand_files() uses a 
> > vmalloc()+vfree() pair in that case.
> 
> hm, perhaps it's not a problem after all. The freeing is done 
> via rcu, and list_del_rcu() leaves the forward pointer intact.
> 
> So how did it happen that the entry got kfree()d before the loop 
> was done? We are in a spinlocked section so the CPU should not 
> have entered rcu processing.

Good point -- is the .config file available?

							Thanx, Paul
