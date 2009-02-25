Return-Path: <linux-kernel-owner+w=401wt.eu-S1762077AbZBYRTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077AbZBYRTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 12:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761472AbZBYRSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 12:18:48 -0500
Received: from ns1.suse.de ([195.135.220.2]:57053 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbZBYRSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 12:18:47 -0500
Date: Wed, 25 Feb 2009 18:18:42 +0100
From: Nick Piggin <npiggin@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, stable@kernel.org, akpm@linux-foundation.org,
       penberg@cs.helsinki.fi
Subject: Re: [PATCH] v4 Teach RCU that idle task is not quiscent state at boot
Message-ID: <20090225171842.GN22785@wotan.suse.de>
References: <20090223161611.GA9563@linux.vnet.ibm.com> <20090223204332.GA19861@linux.vnet.ibm.com> <20090225002937.GA23733@linux.vnet.ibm.com> <20090225141945.GA28455@linux.vnet.ibm.com> <20090225160024.GB12732@elte.hu> <20090225162645.GJ22785@wotan.suse.de> <20090225171249.GD6797@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090225171249.GD6797@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 09:12:49AM -0800, Paul E. McKenney wrote:
> On Wed, Feb 25, 2009 at 05:26:45PM +0100, Nick Piggin wrote:
> > I wonder if you couldn't leave cpu_rq(cpu)->idle as NULL until right
> > up to the point where it actually becomes the "idle" thread? This
> > would make idle_cpu() more truthful for all other callers in early
> > boot code too. And rcupdate shouldn't need any changes (except the
> > num_online_cpus() == 1 shortcut probably remains as a nice opt).
> 
> It looked to me that the idle task initialization was moved early
> to allow interrupt handlers to see a more normal environment, but I
> could easily be confused here.

I think we might be OK. I think interrupt handlers shouldn't care
so much about whether the cpu is idle or not (and seeing !idle
here would be more accurate anyway).

