Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbXKNJcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbXKNJcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 04:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbXKNJc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 04:32:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39068 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455AbXKNJc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 04:32:27 -0500
Date: Wed, 14 Nov 2007 01:32:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Young" <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.24-rc2-mm1
Message-Id: <20071114013217.7739f3fe.akpm@linux-foundation.org>
In-Reply-To: <20071114004129.783fb98b.akpm@linux-foundation.org>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
	<a8e1da0711132218h9d944d0p3c22ac313ee667a9@mail.gmail.com>
	<20071113223802.2ace1a61.akpm@linux-foundation.org>
	<a8e1da0711132247jd440f8dgc9ac0442e90f2c34@mail.gmail.com>
	<20071114004129.783fb98b.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
