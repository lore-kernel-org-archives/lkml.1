Return-Path: <linux-kernel-owner+w=401wt.eu-S1760689AbYFSMtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbYFSMtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbYFSMtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:49:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34588 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754939AbYFSMtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:49:41 -0400
Date: Thu, 19 Jun 2008 14:49:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let MPS support selectable
Message-ID: <20080619124914.GA1843@elte.hu>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200806181432.57204.yhlu.kernel@gmail.com> <200806181729.31464.yhlu.kernel@gmail.com> <200806190018.45944.yhlu.kernel@gmail.com> <20080619121319.GE7640@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619121319.GE7640@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> applied to tip/x86/mpparse, thanks.

-tip testing found an early 64-bit bootup crash:


SMP: Allowing 0 CPUs, 0 hotplug CPUs
PANIC: early exception 0e rip 10:ffffffff804aeb32 error 2 cr2 
ffff810040000000
Pid: 0, comm: swapper Not tainted 2.6.26-rc6 #8188

Call Trace:
 [<ffffffff80233f59>] ? printk+0x77/0x98
 [<ffffffff80d78196>] early_idt_handler+0x56/0x6a
 [<ffffffff804aeb32>] ? memset+0x32/0xc0
 [<ffffffff80d88026>] ? __alloc_bootmem_core+0x1ce/0x372
 [<ffffffff80d88343>] __alloc_bootmem_nopanic+0x35/0x60
 [<ffffffff80d8837f>] __alloc_bootmem+0x11/0x3a
 [<ffffffff80d7d329>] setup_per_cpu_areas+0x8d/0x249
 [<ffffffff80d78d61>] start_kernel+0x175/0x3a4
 [<ffffffff80d78365>] x86_64_start_kernel+0x165/0x16e

RIP 0x10

with this config (1GB RAM system):

  http://redhat.com/~mingo/misc/config-Thu_Jun_19_14_22_37_CEST_2008.bad

so i reverted this patch for now.

	Ingo
