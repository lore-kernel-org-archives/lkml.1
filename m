Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbZESBuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbZESBuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 21:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZESBty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 21:49:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:36466 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbZESBtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 21:49:53 -0400
Subject: Re: Oops in usb-serial with keyspan adapter on current upstream
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <1242695149.16901.17.camel@pasglop>
References: <Pine.LNX.4.44L0.0905181104070.2981-100000@iolanthe.rowland.org>
	 <1242695149.16901.17.camel@pasglop>
Content-Type: text/plain
Date: Tue, 19 May 2009 11:49:19 +1000
Message-Id: <1242697759.16901.42.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 11:05 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2009-05-18 at 11:06 -0400, Alan Stern wrote:
> > On Mon, 18 May 2009, Benjamin Herrenschmidt wrote:
> > 
> > > Hi folks !
> > > 
> > > Current kernels give the oops below at boot with my Keyspan plugged,
> > > used to work fine on 2.6.28 at least.
> > 
> > Does your test kernel include commit 
> > 2d93148ab6988cad872e65d694c95e8944e1b626?
> 
> Yes, it appears so.

So I can still reproduce it with today checkout
(363383277081ce831642b72df40932ee05ce40a2).

Unable to handle kernel paging request for data at address 0x00000010
Faulting instruction address: 0xc000000000301e0c
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=4 PowerMac
Modules linked in: keyspan usbserial
NIP: c000000000301e0c LR: c0000000002fb410 CTR: c0000000002fb29c
REGS: c00000015a4e34c0 TRAP: 0300   Not tainted  (2.6.30-rc6-00065-g3633832)
MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 24000024  XER: 20000000
DAR: 0000000000000010, DSISR: 0000000040000000
TASK = c00000015a494950[170] 'khubd' THREAD: c00000015a4e0000 CPU: 1
GPR00: c0000000008475e8 c00000015a4e3740 c000000000875430 0000000000000001 
GPR04: 0000000000000000 c0000001581e2290 0000000000000001 0000000000000000 
GPR08: 0000000000000000 0000000000000000 0000000000000000 c0000000002fb29c 
GPR12: 0000000024000082 c0000000008a9480 0000000000000002 c0000001581dd230 
GPR16: 00000000000003e8 0000000000000001 c0000001580b0800 c0000001581dd230 
GPR20: 0000000000000000 0000000000000001 c0000001580b1800 0000000000000002 
GPR24: c000000158226c00 c00000015811a780 c0000001581e2198 0000000000000000 
GPR28: 0000000000000000 c00000015a4e37b0 c0000000007fede8 0000000000000000 
NIP [c000000000301e0c] .release_nodes+0x54/0x254
LR [c0000000002fb410] .device_del+0x174/0x1e8
Call Trace:
[c00000015a4e3740] [c00000015a4e3880] 0xc00000015a4e3880 (unreliable)
[c00000015a4e37f0] [c0000000002fb410] .device_del+0x174/0x1e8
[c00000015a4e3880] [d0000000005454dc] .usb_serial_disconnect+0xf8/0x1d0 [usbserial]
[c00000015a4e3930] [c0000000003d1ed0] .usb_unbind_interface+0x7c/0x138
[c00000015a4e39d0] [c0000000002fe77c] .__device_release_driver+0xb8/0x100
[c00000015a4e3a60] [c0000000002fe930] .device_release_driver+0x30/0x54
[c00000015a4e3af0] [c0000000002fd9c8] .bus_remove_device+0xe4/0x124
[c00000015a4e3b80] [c0000000002fb404] .device_del+0x168/0x1e8
[c00000015a4e3c10] [c0000000003cf08c] .usb_disable_device+0xa4/0x15c
[c00000015a4e3cb0] [c0000000003c96ac] .usb_disconnect+0xc4/0x180
[c00000015a4e3d60] [c0000000003ca794] .hub_thread+0x594/0x101c
[c00000015a4e3f00] [c0000000000672b0] .kthread+0x80/0xcc
[c00000015a4e3f90] [c00000000001fef0] .kernel_thread+0x54/0x70
Instruction dump:
ebc2a398 7c7a1b78 7c872378 39000000 3b800000 3be00000 38010070 f8010070 
f8010078 7c1d0378 48000070 e81e8000 <e96a0010> e8840000 7fab0000 419e0014 
---[ end trace f9d8f1b68a9ea04d ]---

Pretty clearly a NULL dereference inside release_nodes() called by
device_del(). After a bit of disassembly, it looks like the offending
dereference is node->release (ie, node_to_group) called with a NULL node,
so basically we got to a situation where cur == NULL in the first loop
inside of remove_nodes() and it thus blows on

	grp = node_to_group(node);

It also looks like first is NULL but it's unclear whether it is such
as the result of first = first->next or the function was called that
way, though I could try to figure it out with added debugging. It -does-
seem that "cnt" might be 1 at the time of the crash.

Do you need more data ?

Cheers,
Ben.





