Return-Path: <linux-kernel-owner+w=401wt.eu-S1761209AbZFPUzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209AbZFPUzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756916AbZFPUzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:55:04 -0400
Received: from relay2.sgi.com ([192.48.179.30]:32978 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754078AbZFPUzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:55:03 -0400
Date: Tue, 16 Jun 2009 15:54:49 -0500
From: Russ Anderson <rja@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rja@sgi.com
Subject: Re: [PATCH 00/22] HWPOISON: Intro (v5)
Message-ID: <20090616205449.GA4858@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20090615024520.786814520@intel.com> <4A35BD7A.9070208@linux.vnet.ibm.com> <20090615042753.GA20788@localhost> <Pine.LNX.4.64.0906151341160.25162@sister.anvils> <20090615140019.4e405d37@lxorguk.ukuu.org.uk> <20090615132934.GE31969@one.firstfloor.org> <20090616194430.GA9545@sgi.com> <4A380086.7020904@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A380086.7020904@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 01:28:54PM -0700, H. Peter Anvin wrote:
> Russ Anderson wrote:
> > On Mon, Jun 15, 2009 at 03:29:34PM +0200, Andi Kleen wrote:
> >> I think you're wrong about killing processes decreasing
> >> reliability. Traditionally we always tried to keep things running if possible
> >> instead of panicing.
> > 
> > Customers love the ia64 feature of killing a user process instead of
> > panicing the system when a user process hits a memory uncorrectable
> > error.  Avoiding a system panic is a very good thing.
> 
> Sometimes (sometimes it's a very bad thing.)
> 
> However, the more fundamental thing is that it is always trivial to
> promote an error to a higher severity; the opposite is not true.  As
> such, it becomes an administrator-set policy, which is what it needs to be.

Good point.  On ia64 the recovery code is implemented as a kernel
loadable module.  Installing the module turns on the feature.

That is handy for customer demos.  Install the module, inject a
memory error, have an application read the bad data and get killed.
Repeat a few times.  Then uninstall the module, inject a
memory error, have an application read the bad data and watch
the system panic.

Then it is the customer's choice to have it on or off.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
