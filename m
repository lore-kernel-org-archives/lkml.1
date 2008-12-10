Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYLJNP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYLJNP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYLJNPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:15:09 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:35375 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYLJNPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:15:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=MGLK7Vc7LWgsnA8vWzhynQ+HrVNMJ0Mx3Gj1izybqDz9et/k0lGut/GMVVbUhXVDnp
         aCEbF8YSvKJGz2RYy0qwuJXsb+TG/R79MG58uSh9fCCA/NdYQvy/TzNQjNBrNAzZHIGO
         BmRew7rVVX0BMftiVnBV3Jk/9Mf1x0n1RsQbM=
Message-ID: <493FC0C5.2070004@gmail.com>
Date: Wed, 10 Dec 2008 14:14:45 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: jeffrey.t.kirsher@intel.com
CC: jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
       peter.p.waskiewicz.jr@intel.com, john.ronciak@intel.com,
       e1000-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: mmotm 2008-12-09-15-24: e1000e mutex contention
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

during bootup, I got ton of these:

WARNING: at drivers/net/e1000e/ich8lan.c:413
e1000_acquire_swflag_ich8lan+0x43/0xf0()
Hardware name: To Be Filled By O.E.M.
e1000e mutex contention. Owned by pid -1
Modules linked in:
Pid: 1, comm: swapper Tainted: G        W  2.6.28-rc7-mm1_64 #490
Call Trace:
 [<ffffffff8023e25f>] warn_slowpath+0xaf/0x110
 [<ffffffff803c1b1d>] ? vt_console_print+0x26d/0x380
 [<ffffffff8023e403>] ? __call_console_drivers+0x73/0x90
 [<ffffffff80259954>] ? up+0x34/0x50
 [<ffffffff8023e98d>] ? release_console_sem+0x1bd/0x210
 [<ffffffff803fe333>] e1000_acquire_swflag_ich8lan+0x43/0xf0
 [<ffffffff803fe748>] e1000_read_nvm_ich8lan+0x78/0x130
 [<ffffffff80401ad1>] e1000e_read_pba_num+0x31/0x80
 [<ffffffff80589609>] e1000_probe+0xcb9/0xd00
 [<ffffffff8035d46a>] ? kobject_get+0x1a/0x30
 [<ffffffff80370092>] local_pci_probe+0x12/0x20
 [<ffffffff80370c50>] pci_device_probe+0x80/0xa0
 [<ffffffff803f36eb>] ? driver_sysfs_add+0x6b/0x90
 [<ffffffff803f3832>] driver_probe_device+0xa2/0x1e0
 [<ffffffff803f3a0b>] __driver_attach+0x9b/0xa0
 [<ffffffff803f3970>] ? __driver_attach+0x0/0xa0
 [<ffffffff803f2ff3>] bus_for_each_dev+0x63/0x90
 [<ffffffff80791560>] ? e1000_init_module+0x0/0x70
 [<ffffffff803f367c>] driver_attach+0x1c/0x20
 [<ffffffff803f28a8>] bus_add_driver+0x1f8/0x270
 [<ffffffff80791560>] ? e1000_init_module+0x0/0x70
 [<ffffffff803f3bf0>] driver_register+0x70/0x160
 [<ffffffff80791560>] ? e1000_init_module+0x0/0x70
 [<ffffffff80370f2a>] __pci_register_driver+0x5a/0xa0
 [<ffffffff80791560>] ? e1000_init_module+0x0/0x70
 [<ffffffff807915af>] e1000_init_module+0x4f/0x70
 [<ffffffff80791360>] ? loop_init+0x0/0x1dc
 [<ffffffff8020903c>] _stext+0x3c/0x170
 [<ffffffff8027f068>] ? register_irq_proc+0xb8/0xe0
 [<ffffffff80300000>] ? load_script+0x70/0x250
 [<ffffffff807726ab>] kernel_init+0x166/0x1c2
 [<ffffffff8020d5ba>] child_rip+0xa/0x20
 [<ffffffff80772545>] ? kernel_init+0x0/0x1c2
 [<ffffffff8020d5b0>] ? child_rip+0x0/0x20
---[ end trace 9c09681510f4b604 ]---

I've found few reports of this in the past, not sure if this one is related.
The last known working is some mmotm based on -rc5.
