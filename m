Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYLEJCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYLEJCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 04:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbYLEJCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 04:02:07 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:23797 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbYLEJCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 04:02:06 -0500
Message-ID: <4938EE0B.8020501@msgid.tls.msk.ru>
Date: Fri, 05 Dec 2008 12:02:03 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Mark McLoughlin <markmc@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
References: <1228394671.3732.77.camel@blaa> <49385DB7.4060306@gmail.com>
In-Reply-To: <49385DB7.4060306@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 12/04/2008 01:44 PM, Mark McLoughlin wrote:
>> Nothing takes a ref on virtio_pci, so even if you have
>> devices in use, rmmod will attempt to unload the module.
> 
> It unbinds the device properly as any other driver. So what's the problem here?

Here's what we get when rmmod'ing (a zero-refcounted but
in use) virtio_pci (I did it by a chance, cut-n-pasted
the wrong line):

WARNING: at drivers/base/core.c:122 device_release+0x5f/0x70()
Device 'virtio1' does not have a release() function, it is broken and must be fixed.
Modules linked in: ext3 jbd mbcache acpiphp dock pci_hotplug virtio_net virtio_blk virtio_pci(-) virtio_ring virtio

Pid: 361, comm: rmmod Tainted: G S        2.6.27-i686smp #2.6.27.7
 [<c012b81f>] warn_slowpath+0x6f/0xa0
 [<c0110030>] prepare_set+0x30/0x80
 [<c012067e>] __wake_up+0x3e/0x60
 [<c01d1d25>] release_sysfs_dirent+0x45/0xb0
 ...

>> Reported-by: Michael Tokarev <mjt@tls.msk.ru>

It was in my original report to kvm@vger.

Thanks!

/mjt
