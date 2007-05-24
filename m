Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbXEXBvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbXEXBvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757819AbXEXBvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:51:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:10941 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745AbXEXBvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hfulcs45TaI5s6KZf9PkEif5MmyeEXRXGu3Xr1gL6yAQ6CvQLDY4GUGU7aHgHRUDwgez+VDcS2UbipU2GY1BzS0EwxR3RFWpQyGfDdX4y/czcqpN50wVJY7ESNPeP6Q9inIFkHt45lbdltMaall1eFGNcZIwAXqOI5KwAyBn+88=
Message-ID: <76366b180705231851k42eba520jb07113a669c1e598@mail.gmail.com>
Date: Wed, 23 May 2007 21:51:42 -0400
From: "Andrew Paprocki" <andrew.m.paprocki@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc2 amd64 slab allocator bug reported at boot time
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Snippet from dmesg output (the full dmesg output was attached to my
previous e-mail right before this one regarding 2.6.22-rc2 amd64+4gb
ram agpgart bug):

PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
BUG: at /usr/src/linux-2.6.22-rc2/mm/slab.c:777 __find_general_cachep()

Call Trace:
 [<ffffffff802743dc>] __kmalloc+0x3e/0xbe
 [<ffffffff8021d65f>] cache_k8_northbridges+0x7f/0xf0
 [<ffffffff8052bb53>] gart_iommu_init+0x13/0x4f8
 [<ffffffff802d15e1>] kobject_shadow_add+0xef/0x1a2
 [<ffffffff802d13fb>] kobject_get+0x12/0x17
 [<ffffffff8033b2a4>] class_register+0x10a/0x13d
 [<ffffffff80527964>] pci_iommu_init+0x9/0x12
 [<ffffffff8052060e>] kernel_init+0x167/0x2d7
 [<ffffffff8020aba8>] child_rip+0xa/0x12
 [<ffffffff802fb7e4>] acpi_ds_init_one_object+0x0/0x7c
 [<ffffffff805204a7>] kernel_init+0x0/0x2d7
 [<ffffffff8020ab9e>] child_rip+0x0/0x12

PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz

-Andrew
