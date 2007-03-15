Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXCOHXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXCOHXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 03:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXCOHXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 03:23:13 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42609 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290AbXCOHXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 03:23:12 -0400
Date: Thu, 15 Mar 2007 00:22:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: paulus@samba.org, clameter@sgi.com, linux-kernel@vger.kernel.org,
       ak@suse.com, holt@sgi.com, linux-ia64@vger.kernel.org, mpm@selenic.com
Subject: Re: [QUICKLIST 0/6] Arch independent quicklists V1
Message-Id: <20070315002249.9e531578.akpm@linux-foundation.org>
In-Reply-To: <20070312.193211.30184040.davem@davemloft.net>
References: <20070312.155157.74747634.davem@davemloft.net>
	<17909.62028.117035.287313@cargo.ozlabs.ibm.com>
	<20070312.192616.63128242.davem@davemloft.net>
	<20070312.193211.30184040.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 12 Mar 2007 19:32:11 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 12 Mar 2007 19:26:16 -0700 (PDT)
> 
> > From: Paul Mackerras <paulus@samba.org>
> > Date: Tue, 13 Mar 2007 11:37:32 +1100
> > 
> > > David Miller writes:
> > > 
> > > > I ported this to sparc64 as per the patch below, tested on
> > > > UP SunBlade1500 and 24 cpu Niagara T1000.
> > > 
> > > Did you see any performance improvement?  We used to have quicklists
> > > on ppc, but I remain to be convinced that they actually help.
> > 
> > It shaved about 3 or 4 seconds consistently off of my kernel
> > build on Niagara which usually clocks in just over 4 minutes
> > on this 24 thread machine.
> 
> I want to quantify this with the fact that all the cache false sharing
> issues are irrelevant in this test because the L2 cache is shared
> between all of the cpu threads on Niagara.
> 
> It was fast just because the quicklists were lighter weight than the
> SLAB stuff.

So...  what would happen if sparc64 were to use neither quicklists nor
slab?  Just grab these pages from the page allocator and clear them?

