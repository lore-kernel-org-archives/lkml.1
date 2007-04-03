Return-Path: <linux-kernel-owner+w=401wt.eu-S2992472AbXDCWxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992472AbXDCWxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992476AbXDCWxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:53:32 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39871 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992472AbXDCWxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:53:31 -0400
Subject: Re: 2.6.21-rc5-mm4
From: Badari Pulavarty <pbadari@gmail.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704031339080.11001@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	 <1175632311.6185.1.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0704031339080.11001@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 15:53:32 -0700
Message-Id: <1175640812.6185.6.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 13:40 -0700, Christoph Lameter wrote:
> On Tue, 3 Apr 2007, Badari Pulavarty wrote:
> 
> > On Mon, 2007-04-02 at 22:47 -0700, Andrew Morton wrote:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> > > 
> > 
> > SLUB code hangs my ppc64 machine on boot.
> 
> Could you enable NMI or something and get me a stackdump? PPC is notorious 
> for having strange NUMA issues. Any fallbacks from node 0 on bootstrap? Is 
> there memory on node 0?


Seems to be an issue with calibrate_delay() spinning in a tight
loop :(

BTW, machine boots fine with SLAB code - not sure why ?

Thanks,
Badari

SLUB V6: General Slabs=18, HW alignment=128, Processors=8, Nodes=16
cpu 0x0: Vector: 100 (System Reset) at [c000000000723bc0]
    pc: c00000000000999c: .calibrate_delay+0x90/0x1a8
    lr: c000000000009988: .calibrate_delay+0x7c/0x1a8
    sp: c000000000723e40
   msr: 8000000000081032
  current = 0xc00000000060ef50
  paca    = 0xc00000000060f800
    pid   = 0, comm = swapper
enter ? for help
[c000000000723ee0] c0000000005a7900 .start_kernel+0x334/0x3f4
[c000000000723f90] c000000000008524 .start_here_common+0x54/0x130
00 = 00000000ffff8adc   R16 = 0000000000000000
R01 = c000000000723e40   R17 = 0000000000000000
R02 = c0000000007207d8   R18 = 0000000000000000
R03 = 0000000000002000   R19 = 4000000001c00000
R04 = 0000000000000001   R20 = c0000000005dc618
R05 = 0000000000000001   R21 = 00000000021dc888
R06 = 0000000000000000   R22 = 0000000000000000
R07 = c00000000063fa38   R23 = c0000000005dc888
R08 = 000000000007ffff   R24 = 00000000021dc618
R09 = c000000000736400   R25 = 0000000001a3f9a0
R10 = c000000000766f80   R26 = c000000000758000
R11 = 00000000ffff8adc   R27 = c000000000759030
R12 = c000000000647ad0   R28 = c0000000007598b0
R13 = c00000000060f800   R29 = 0000000000000000
R14 = 0000000000000000   R30 = c0000000005f3db8
R15 = 0000000000000000   R31 = c000000000736400
pc  = c00000000000999c .calibrate_delay+0x90/0x1a8
lr  = c000000000009988 .calibrate_delay+0x7c/0x1a8
msr = 8000000000081032   cr  = 24002042
ctr = 0000000000000000   xer = 0000000000000005   trap =  100


