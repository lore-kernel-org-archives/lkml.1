Return-Path: <linux-kernel-owner+w=401wt.eu-S933040AbXKOUrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933040AbXKOUrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbXKOUrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:47:36 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753039AbXKOUrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:47:35 -0500
Date: Thu, 15 Nov 2007 12:47:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2-mm1
Message-Id: <20071115124732.9dc3fde5.akpm@linux-foundation.org>
In-Reply-To: <20071115192537.GB30186@kroah.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<20071115192537.GB30186@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 11:25:37 -0800
Greg KH <greg@kroah.com> wrote:

> I'll roll it into my larger patchset so that Andrew can get it
> automatically for the next release.

hm, thanks.

Did we hunt down that warning I found?

umm.. this:

On Wed, 14 Nov 2007 00:41:29 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> There's some kobject warning which comes out when
> gregkh-driver-kset-convert-block_subsys-to-use-kset_create.patch isn't
> applied.  More bisecting coming up..


[   11.863390] ACPI: AC Adapter [ACAD] (on-line)
[   11.868004] ACPI: Battery Slot [BAT1] (battery present)
[   11.922945] Real Time Clock Driver v1.12ac
[   11.923078] intel_rng: FWH not detected
[   11.923160] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[   14.934078] floppy0: no floppy controllers found
[   14.934616] WARNING: at lib/kref.c:33 kref_get()
[   14.934690]  [<c0242810>] kref_get+0x40/0x50
[   14.934766]  [<c024185f>] kobject_get+0xf/0x20
[   14.934839]  [<c0241e7f>] kobject_add+0x14f/0x1a0
[   14.934917]  [<c0241c8e>] kobject_set_name+0x7e/0xc0
[   14.934998]  [<c01b82af>] register_disk+0x3f/0x200
[   14.935078]  [<c02392ff>] blk_register_region+0x2f/0x40
[   14.935164]  [<c0239349>] add_disk+0x39/0x50
[   14.935234]  [<c0238b80>] exact_match+0x0/0x10
[   14.935306]  [<c0239120>] exact_lock+0x0/0x10
[   14.935378]  [<c051b73b>] loop_init+0x13b/0x190
[   14.935453]  [<c0500570>] kernel_init+0x130/0x300
[   14.935532]  [<c010428e>] ret_from_fork+0x6/0x1c
[   14.938302]  [<c0500440>] kernel_init+0x0/0x300
[   14.941033]  [<c0500440>] kernel_init+0x0/0x300
[   14.943732]  [<c0104f8f>] kernel_thread_helper+0x7/0x18
[   14.946436]  =======================
[   14.949535] loop: module loaded
[   14.952336] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   14.955022] e100: Copyright(c) 1999-2006 Intel Corporation
[   14.957813] ACPI: PCI Interrupt 0000:06:08.0[A] -> GSI 20 (level, low) -> IRQ

Caused by gregkh-driver-remove-struct-kobj_type-from-struct-kset.patch
