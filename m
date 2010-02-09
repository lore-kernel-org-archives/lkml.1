Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab0BIQz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 11:55:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab0BIQz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 11:55:26 -0500
Date: Tue, 9 Feb 2010 17:52:48 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml@Think-Future.de, Linux Kernel-Liste <linux-kernel@vger.kernel.org>,
       Reinette Chatre <reinette.chatre@intel.com>, ilw@linux.intel.com,
       linux-wireless@vger.kernel.org
Subject: Re: PROBLEM: iwlagn kernel 2.6.32.3 ooops
Message-ID: <20100209165247.GB2512@dhcp-lab-161.englab.brq.redhat.com>
References: <20100206170348.GB9411@localhost> <20100208143118.e8e5a1ee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208143118.e8e5a1ee.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 02:31:18PM -0800, Andrew Morton wrote:
> On Sat, 6 Feb 2010 18:03:50 +0100
> lkml@Think-Future.de wrote:
> 
> >   Hi, 
> 
> Suitable cc's added, more below...
> 
> > This ooops happens on kernel 2.6.32.3. On a .32.7 it didn't 
> > happen yet. Maybe fixed, maybe not.
> > 
> > Keywords (i.e., modules, networking, kernel):
> > iwlagn, kernel 2.6.32.3
> > 
> > 
> > Below two msgs:
> > The first is the ooops that occurred when using the box as usual (IRC: after 
> > this crash no rmmod && modprobe have been possible).
> > 
> > The second - IRC - when the iwlagn module crashed, rebooted, crashed differently, 
> > was then removed after the different ooops and re-modprobed.
> > 
> > 
> > [250420.677157] ip: page allocation failure. order:3, mode:0x8020
> 
> This one isn't an "oops" - it's a warning that a memory allocation
> attempt failed.  Which is hardly surprising: an order-3 GFP_ATOMIC
> allocation is highly unreliable and the driver just shouldn't be
> attempting it.
> 
> > [250420.677168] Pid: 11584, comm: ip Not tainted 2.6.32.3 #5
> > [250420.677173] Call Trace:
> > [250420.677190]  [<c10a53f8>] ? __alloc_pages_nodemask+0x518/0x5f0
> > [250420.677204]  [<c1007c20>] ? dma_generic_alloc_coherent+0x0/0x100
> > [250420.677214]  [<c1007c92>] ? dma_generic_alloc_coherent+0x72/0x100
> > [250420.677224]  [<c1007c20>] ? dma_generic_alloc_coherent+0x0/0x100
> > [250420.677241]  [<fca1c9d5>] ? iwl_tx_queue_init+0x285/0x380 [iwlcore]

That is at initialization time. To avoid atomic allocation we can just
use dma_alloc_coherent instead of pci_alloc_consistent. I'm going to
prepare a patch.

Stanislaw
