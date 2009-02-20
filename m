Return-Path: <linux-kernel-owner+w=401wt.eu-S1752830AbZBTHd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbZBTHd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 02:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbZBTHdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 02:33:37 -0500
Received: from www17.your-server.de ([213.133.104.17]:44813 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbZBTHdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 02:33:35 -0500
Subject: Re: [Announce] 2.6.29-rc4-rt2
From: Thomas Meyer <thomas@m3y3r.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 07:32:48 +0100
Message-Id: <1235111568.3363.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 12.02.2009, 23:56 +0100 schrieb Thomas Gleixner: 
> We are pleased to announce the first update to our new preempt-rt
> series. It fixes the reported bugs and some more.
> 
> Download locations:
> 
>    http://rt.et.redhat.com/download/
>    http://www.kernel.org/pub/linux/kernel/projects/rt/
>  
> Information on the RT patch can be found at:
> 
>   http://rt.wiki.kernel.org/index.php/Main_Page
> 
> to build the 2.6.29-rc4-rt2 tree, the following patches should be
> applied:
> 
>   http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc4.tar.bz2
>   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc4-rt2.bz2
> 
> The broken out patches are also available at the same download
> locations.
> 
> Enjoy !
> 
>       Thomas, Ingo

Hi,

Are you interested in these BUG reports?

Without CONFIG_HIGHPTE kernel boots and seems to work correct, but I'm
hitting these two BUGs:

[   19.840100] BUG: sleeping function called from invalid context at arch/x86/mm/highmem_32.c:8
[   19.840105] in_atomic(): 0, irqs_disabled(): 1, pid: 718, name: IRQ-14
[   19.840110] Pid: 718, comm: IRQ-14 Tainted: G        W  2.6.29-rc4-rt2-tip #55
[   19.840113] Call Trace:
[   19.840123]  [<c0444cbd>] __might_sleep+0xda/0xf0
[   19.840128]  [<c043ee31>] kmap+0x50/0x77
[   19.840133]  [<c0663e35>] sg_miter_next+0xc1/0xdf
[   19.840137]  [<c0663ee8>] sg_copy_buffer+0x95/0xc5
[   19.840141]  [<c0663f35>] sg_copy_to_buffer+0x1d/0x33
[   19.840149]  [<c0774ab1>] atapi_qc_complete+0x25a/0x2c5
[   19.840153]  [<c076dece>] __ata_qc_complete+0xb4/0xcd
[   19.840157]  [<c076f844>] ata_qc_complete+0x1be/0x1d7
[   19.840162]  [<c077c812>] ata_hsm_qc_complete+0xa9/0xd3
[   19.840166]  [<c077ceb7>] ata_sff_hsm_move+0x67b/0x6da
[   19.840171]  [<c077d19b>] ata_sff_interrupt+0x15d/0x205
[   19.840176]  [<c049440a>] handle_IRQ_event+0x4b/0xce
[   19.840180]  [<c0494ac7>] do_irqd+0x141/0x271
[   19.840184]  [<c0494986>] ? do_irqd+0x0/0x271
[   19.840189]  [<c0467022>] kthread+0x4a/0x82
[   19.840192]  [<c0466fd8>] ? kthread+0x0/0x82
[   19.840197]  [<c0420b67>] kernel_thread_helper+0x7/0x10

and:
[  357.286589] BUG: sleeping function called from invalid context at arch/x86/mm/highmem_32.c:8
[  357.286597] in_atomic(): 0, irqs_disabled(): 1, pid: 718, name: IRQ-14
[  357.286605] Pid: 718, comm: IRQ-14 Tainted: G        W  2.6.29-rc4-rt2-tip #55
[  357.286611] Call Trace:
[  357.286624]  [<c0444cbd>] __might_sleep+0xda/0xf0
[  357.286631]  [<c043ee31>] kmap+0x50/0x77
[  357.286640]  [<c0663e35>] sg_miter_next+0xc1/0xdf
[  357.286647]  [<c0663ee8>] sg_copy_buffer+0x95/0xc5
[  357.286654]  [<c0663f35>] sg_copy_to_buffer+0x1d/0x33
[  357.286664]  [<c0774ab1>] atapi_qc_complete+0x25a/0x2c5
[  357.286672]  [<c076dece>] __ata_qc_complete+0xb4/0xcd
[  357.286680]  [<c076f844>] ata_qc_complete+0x1be/0x1d7
[  357.286688]  [<c09ab024>] ? __spin_unlock+0x1e/0x43
[  357.286696]  [<c077c812>] ata_hsm_qc_complete+0xa9/0xd3
[  357.286703]  [<c077ceb7>] ata_sff_hsm_move+0x67b/0x6da
[  357.286711]  [<c077d19b>] ata_sff_interrupt+0x15d/0x205
[  357.286720]  [<c049440a>] handle_IRQ_event+0x4b/0xce
[  357.286727]  [<c0494ac7>] do_irqd+0x141/0x271
[  357.286734]  [<c0494986>] ? do_irqd+0x0/0x271
[  357.286742]  [<c0467022>] kthread+0x4a/0x82
[  357.286757]  [<c0466fd8>] ? kthread+0x0/0x82
[  357.286762]  [<c0420b67>] kernel_thread_helper+0x7/0x10

greets
thomas


