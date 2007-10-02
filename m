Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbXJBKuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbXJBKuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 06:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXJBKtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 06:49:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52164 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbXJBKty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 06:49:54 -0400
Date: Tue, 02 Oct 2007 19:48:00 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: x86 patches was Re: -mm merge plans for 2.6.24
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com,
       "Huang, Ying" <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Lameter <clameter@sgi.com>, apw@shadowen.org,
       "Lee.Schermerhorn@hp.com" <Lee.Schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071002171631.46888326.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071002004324.be030b63.akpm@linux-foundation.org> <20071002171631.46888326.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071002180930.2796.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2 Oct 2007 00:43:24 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 2 Oct 2007 16:36:24 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> 
> > > > Don't think so.  A node is a lump of circuitry which can have zero or more
> > > > CPUs, IO and memory.
> > > > 
> > > > It may initially have been conceived as a memory-only concept in the Linux
> > > > kernel, but that doesn't fully map onto reality (does it?)
> > > > 
> > > > There was a real-world need for this, I think from the Fujitsu guys.  That
> > > > should be spelled out in the changelog but isn't.
> > > 
> > > Yes, Fujitsu and HP guys really need this memory-less-node support. 
> > > 
> > 
> > For what reason, please?
> > 
> 
> For fujitsu, problem is called "empty" node.
> 
> When ACPI's SRAT table includes "possible nodes", ia64 bootstrap(acpi_numa_init)
> creates nodes, which includes no memory, no cpu.
> 
> I tried to remove empty-node in past, but that was denied.
> It was because we can hot-add cpu to the empty node.
> (node-hotplug triggered by cpu is not implemented now. and it will be ugly.)
> 
> 
> For HP, (Lee can comment on this later), they have memory-less-node.
> As far as I hear, HP's machine can have following configration.
> 
> (example)
> Node0: CPU0   memory AAA MB
> Node1: CPU1   memory AAA MB
> Node2: CPU2   memory AAA MB
> Node3: CPU3   memory AAA MB
> Node4: Memory XXX GB
> 
> AAA is very small value (below 16MB)  and will be omitted by ia64 bootstrap.
> After boot, only Node 4 has valid memory (but have no cpu.)
> 
> Maybe this is memory-interleave by firmware config.

>From memory-hotplug view, memory-less node is very helpful.
It can define and arrange some "halfway conditions" of node hot-plug.
I guess that node unpluging code will be simpler by it.


Bye.

-- 
Yasunori Goto 


