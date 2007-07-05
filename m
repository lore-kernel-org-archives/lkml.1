Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbXGEAUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbXGEAUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 20:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbXGEATx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 20:19:53 -0400
Received: from canuck.infradead.org ([209.217.80.40]:40122 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518AbXGEATu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 20:19:50 -0400
Subject: Re: [1/2] 2.6.22-rc7: known regressions
From: David Woodhouse <dwmw2@infradead.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <468A7D14.1050505@googlemail.com>
References: <468A7D14.1050505@googlemail.com>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 20:20:13 -0400
Message-Id: <1183594813.3059.0.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 18:45 +0200, Michal Piotrowski wrote:
> Subject    : random invalid instruction occourances on sparc32 (sun4c)
> References : http://lkml.org/lkml/2007/6/17/111
> Submitter  : Mark Fortescue <mark@mtfhpc.demon.co.uk>
> Status     : problem is being debugged 

Hm, when testing the fix for that on ppc32, I stupidly built with Slub
instead, and got this...

radeonfb: Monitor 1 type LCD found
radeonfb: EDID probed
radeonfb: Monitor 2 type no found
radeonfb: Using Firmware dividers 0x00040080 from PPLL 0
radeonfb: Dynamic Clock Power Management enabled
*** SLUB kmalloc-32768: Poison check failed@0xc1e20000 slab 0xc04de400 [Not tainted]
    offset=0 flags=0x40c3 inuse=0 freelist=0xc1e20000
    Object 0xc1e20000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
    Object 0xc1e20010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
    Object 0xc1e20020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
    Object 0xc1e20030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
    Object 0xc1e20040:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
    Object 0xc1e20050:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
    Object 0xc1e20060:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
    Object 0xc1e20070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
   Redzone 0xc1e28000:  bb bb bb bb                                     <BB><BB><BB><BB>            
FreePointer 0xc1e28004 -> 0x00000000
Last alloc: malloc+0x14/0x24 jiffies_ago=1382 cpu=0 pid=1
Last free : free+0x10/0x20 jiffies_ago=837 cpu=0 pid=1
    Filler 0xc1e28028:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
Call Trace:
[effc7b80] [c000893c] show_stack+0x50/0x184 (unreliable)
[effc7ba0] [c009705c] object_err+0x178/0x18c
[effc7bc0] [c0097380] check_object+0x180/0x2ec
[effc7be0] [c0098320] __slab_alloc+0x5c8/0x5f4
[effc7c10] [c0098aa4] __kmalloc+0x64/0x9c
[effc7c30] [c015f5dc] fbcon_startup+0x154/0x2c0
[effc7c60] [c01bb8ec] register_con_driver+0x94/0x164
[effc7c90] [c01bedc8] take_over_console+0x24/0x58
[effc7cb0] [c015b41c] fbcon_takeover+0x8c/0xec
[effc7cc0] [c015d31c] fbcon_event_notify+0x1e0/0x6c8
[effc7d90] [c02d9490] notifier_call_chain+0x3c/0x94
[effc7db0] [c0045468] __blocking_notifier_call_chain+0x50/0x74
[effc7dd0] [c014f514] fb_notifier_call_chain+0x24/0x34
[effc7de0] [c0150590] register_framebuffer+0x190/0x1a8
[effc7e40] [c0185450] radeonfb_pci_register+0xe54/0xf50
[effc7e70] [c0145b04] pci_device_probe+0x6c/0xa0
[effc7e90] [c01d4108] driver_probe_device+0xfc/0x1a0
[effc7eb0] [c01d436c] __driver_attach+0xac/0x110
[effc7ed0] [c01d32f0] bus_for_each_dev+0x50/0x94
[effc7f00] [c01d3efc] driver_attach+0x24/0x34
[effc7f10] [c01d3710] bus_add_driver+0x78/0x1a0
[effc7f30] [c01d468c] driver_register+0x88/0x9c
[effc7f40] [c0145900] __pci_register_driver+0x6c/0xb8
[effc7f60] [c03e8e4c] radeonfb_init+0x20c/0x220
[effc7f80] [c03c82e4] kernel_init+0xc8/0x284
[effc7ff0] [c0013e28] kernel_thread+0x44/0x60
@@@ SLUB kmalloc-32768: Restoring Poison (0x6b) from 0xc1e20000-0xc1e27ffe
@@@ SLUB kmalloc-32768: Restoring Poison (0xa5) from 0xc1e27fff-0xc1e27fff
@@@ SLUB: kmalloc-32768 slab 0xc04de400. Marking all objects used.
Console: switching to colour frame buffer device 180x56


-- 
dwmw2

