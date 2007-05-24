Return-Path: <linux-kernel-owner+w=401wt.eu-S1751335AbXEXWf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335AbXEXWf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbXEXWfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:35:48 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49856 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750846AbXEXWfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:35:46 -0400
Date: Thu, 24 May 2007 15:35:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1
In-Reply-To: <20070524145517.1f32cd94.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
 <46540DB2.5000605@googlemail.com> <Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
 <4654AC94.6080601@googlemail.com> <20070523150122.f9946f37.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
 <20070523153730.e0e9e91d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
 <20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
 <20070524073131.GA17501@elte.hu> <Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>
 <20070524142908.f39f42ea.akpm@linux-foundation.org>
 <20070524145517.1f32cd94.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Randy Dunlap wrote:

> This is pretty-printing.  and creature-feep.
> But lib/hexdump.c can probably do this if we add a "prefix/tag" string
> parameter to it.
> 
> Hugh D. wants it to print 32-bit quantities, not just bytes.
> Yet another parameter.
> 
> I'll look into these unless Christoph et al does so first.

I'd appreciate if you could do this. I just added a call to the function 
in hexdump.c and got this ugly output. I think we need

1. byte output

2. A way to specify the width of the description.


BUG kmalloc-16: Redzone corrupted. Expected 0xcc at 0xffff81000235ff30 but 
found 0x12
INFO: Last alloc: slab_sysfs_init+0xe1/0x280 jiffies_ago=0 cpu=0 pid=1
INFO: Object=0xffff81000235ff20 slab=0xffff81000107bcc8 offset=3872
INFO: flags=0x4000000000000082 inuse=45 freelist=0xffff81000235ff78
Bytes b4ffff81000235ff10: 00000000 00000000 5a5a5a5a 5a5a5a5a  ........ZZZZZZZZ
Objectffff81000235ff20: 00000000 00000000 00000000 00000000  ................
Redzoneffff81000235ff30: 12cccccc cccccccc  .IIIIIII
FreePointer 0xffff81000235ff38 -> 0xffff81000235ff78
Fillerffff81000235ff70: 5a5a5a5a 5a5a5a5a  ZZZZZZZZ

Call Trace:
 [<ffffffff8026d2af>] check_bytes_and_report+0x7f/0xe0
 [<ffffffff8026d573>] check_object+0x63/0x260
 [<ffffffff8026fd75>] validate_slab+0x175/0x1b0
 [<ffffffff8026fdc9>] validate_slab_slab+0x19/0x70
 [<ffffffff8026fe76>] validate_slab_cache+0x56/0x110
 [<ffffffff805d2466>] slab_sysfs_init+0x106/0x280
 [<ffffffff805c3624>] kernel_init+0xb4/0x290
 [<ffffffff8020a218>] child_rip+0xa/0x12
 [<ffffffff8038dd68>] acpi_ds_init_one_object+0x0/0x7c
 [<ffffffff805c3570>] kernel_init+0x0/0x290
 [<ffffffff8020a20e>] child_rip+0x0/0x12

FIX kmalloc-16: Restoring Redzone (0xcc) from 0xffff81000235ff30-0xffff81000235ff30


