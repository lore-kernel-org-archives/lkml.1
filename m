Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbXJBIPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbXJBIPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 04:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbXJBIPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 04:15:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36571 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbXJBIPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 04:15:15 -0400
Date: Tue, 2 Oct 2007 17:16:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, "Huang, Ying" <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, apw@shadowen.org,
       "Lee.Schermerhorn@hp.com" <Lee.Schermerhorn@hp.com>
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
Message-Id: <20071002171631.46888326.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071002004324.be030b63.akpm@linux-foundation.org>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	<p733awu6nva.fsf@bingen.suse.de>
	<20071001233225.88c67e8b.akpm@linux-foundation.org>
	<20071002070110.GA30490@one.firstfloor.org>
	<20071002001809.0a814d0b.akpm@linux-foundation.org>
	<20071002163624.74534e7f.kamezawa.hiroyu@jp.fujitsu.com>
	<20071002004324.be030b63.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007 00:43:24 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 2 Oct 2007 16:36:24 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> 
> > > Don't think so.  A node is a lump of circuitry which can have zero or more
> > > CPUs, IO and memory.
> > > 
> > > It may initially have been conceived as a memory-only concept in the Linux
> > > kernel, but that doesn't fully map onto reality (does it?)
> > > 
> > > There was a real-world need for this, I think from the Fujitsu guys.  That
> > > should be spelled out in the changelog but isn't.
> > 
> > Yes, Fujitsu and HP guys really need this memory-less-node support. 
> > 
> 
> For what reason, please?
> 

For fujitsu, problem is called "empty" node.

When ACPI's SRAT table includes "possible nodes", ia64 bootstrap(acpi_numa_init)
creates nodes, which includes no memory, no cpu.

I tried to remove empty-node in past, but that was denied.
It was because we can hot-add cpu to the empty node.
(node-hotplug triggered by cpu is not implemented now. and it will be ugly.)


For HP, (Lee can comment on this later), they have memory-less-node.
As far as I hear, HP's machine can have following configration.

(example)
Node0: CPU0   memory AAA MB
Node1: CPU1   memory AAA MB
Node2: CPU2   memory AAA MB
Node3: CPU3   memory AAA MB
Node4: Memory XXX GB

AAA is very small value (below 16MB)  and will be omitted by ia64 bootstrap.
After boot, only Node 4 has valid memory (but have no cpu.)

Maybe this is memory-interleave by firmware config.

Thanks,
-Kame

