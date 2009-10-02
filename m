Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbZJBJqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbZJBJqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbZJBJqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:46:22 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:48200 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbZJBJqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:46:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=hQs1XWgBuLFwXErUcWsPIDMtkmIJ67cPx/XhjQKGR8wciT04SQhj7TByVAe7JqTPZB
         KuJbE0x6WDJ7tmk4N93Uxg1Lbz9EvBqFb39eRvvjpcqerZE6Ht3yasQBA4NgUy44l+1f
         Aj6XlM3b0d5OMqi0j4H9HxY/iIHEDLWkdIEIg=
MIME-Version: 1.0
Date: Fri, 2 Oct 2009 13:46:23 +0400
Message-ID: <a4423d670910020246n1e82644bud8b7a01d49b93e26@mail.gmail.com>
Subject: 2.6.32-rc2: Intel(R) I/OAT DMA Engine init failed
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
The kerneil is 2.6.32-rc2-00196-g0efe5e3.
Should I bisect?

ioatdma: Intel(R) QuickData Technology Driver 4.00
ioatdma 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ioatdma 0000:00:08.0: setting latency timer to 64
  alloc irq_desc for 33 on node -1
  alloc kstat_irqs on node -1
ioatdma 0000:00:08.0: irq 33 for MSI/MSI-X
ioatdma 0000:00:08.0: Self-test copy timed out, disabling
ioatdma 0000:00:08.0: Intel(R) I/OAT DMA Engine init failed
------------[ cut here ]------------
WARNING: at lib/debugobjects.c:254 debug_print_object+0x64/0x90()
Hardware name: PowerEdge 1950
ODEBUG: free active object type: timer_list
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.32-rc2-00196-g0efe5e3 #1
Call Trace:
 [<c10395b8>] warn_slowpath_common+0x78/0xc0
 [<c12475b4>] ? debug_print_object+0x64/0x90
 [<c12475b4>] ? debug_print_object+0x64/0x90
 [<c1039671>] warn_slowpath_fmt+0x31/0x50
 [<c12475b4>] debug_print_object+0x64/0x90
 [<c1247b34>] debug_check_no_obj_freed+0x104/0x1b0
 [<c1069511>] ? debug_check_no_locks_freed+0xc1/0x140
 [<c10af922>] kfree+0xf2/0x140
 [<c107b913>] ? free_irq+0x43/0x90
 [<c12cd443>] ? release_nodes+0x143/0x1c0
 [<c12cd443>] release_nodes+0x143/0x1c0
 [<c12cd5df>] devres_release_all+0x3f/0x70
 [<c12ca4f7>] driver_probe_device+0xe7/0x290
 [<c140d8e7>] ? _spin_unlock_irqrestore+0x47/0x90
 [<c12ca739>] __driver_attach+0x99/0xa0
 [<c12ca6a0>] ? __driver_attach+0x0/0xa0
 [<c12c9748>] bus_for_each_dev+0x58/0x90
 [<c12ca234>] driver_attach+0x24/0x40
 [<c12ca6a0>] ? __driver_attach+0x0/0xa0
 [<c12c9be7>] bus_add_driver+0x1e7/0x2b0
 [<c125b7e0>] ? pci_device_remove+0x0/0x60
 [<c12caab0>] driver_register+0x70/0x140
 [<c1246ebf>] ? __spin_lock_init+0x3f/0x80
 [<c125bb7d>] __pci_register_driver+0x5d/0xe0
 [<c15e7997>] ioat_init_module+0x6d/0x96
 [<c1001068>] do_one_initcall+0x38/0x1b0
 [<c15e792a>] ? ioat_init_module+0x0/0x96
 [<c15c2497>] kernel_init+0x140/0x1a8
 [<c15c2357>] ? kernel_init+0x0/0x1a8
 [<c1003edb>] kernel_thread_helper+0x7/0x7c
---[ end trace 42ae668ed52462d6 ]---
ioatdma 0000:00:08.0: PCI INT A disabled
