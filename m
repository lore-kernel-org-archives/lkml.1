Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYLGIao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYLGIao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 03:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbYLGIaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 03:30:19 -0500
Received: from ozlabs.org ([203.10.76.45]:37055 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474AbYLGIaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 03:30:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
Date: Sun, 7 Dec 2008 19:00:08 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Michael Tokarev <mjt@tls.msk.ru>, Mark McLoughlin <markmc@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       kvm <kvm@vger.kernel.org>, Anthony Liguori <aliguori@us.ibm.com>,
       Greg KH <gregkh@suse.de>
References: <1228394671.3732.77.camel@blaa> <4938EE0B.8020501@msgid.tls.msk.ru> <493929D2.4070900@gmail.com>
In-Reply-To: <493929D2.4070900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812071900.08987.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2008 23:47:06 Jiri Slaby wrote:
> Michael Tokarev napsal(a):
> > Jiri Slaby wrote:
> >> On 12/04/2008 01:44 PM, Mark McLoughlin wrote:
> >>> Nothing takes a ref on virtio_pci, so even if you have
> >>> devices in use, rmmod will attempt to unload the module.
> >> It unbinds the device properly as any other driver. So what's the problem here?
> > 
> > Here's what we get when rmmod'ing (a zero-refcounted but
> > in use) virtio_pci (I did it by a chance, cut-n-pasted
> > the wrong line):
> > 
> > WARNING: at drivers/base/core.c:122 device_release+0x5f/0x70()
> > Device 'virtio1' does not have a release() function, it is broken and must be fixed.
> > Modules linked in: ext3 jbd mbcache acpiphp dock pci_hotplug virtio_net virtio_blk virtio_pci(-) virtio_ring virtio
> > 
> > Pid: 361, comm: rmmod Tainted: G S        2.6.27-i686smp #2.6.27.7
> >  [<c012b81f>] warn_slowpath+0x6f/0xa0
> >  [<c0110030>] prepare_set+0x30/0x80
> >  [<c012067e>] __wake_up+0x3e/0x60
> >  [<c01d1d25>] release_sysfs_dirent+0x45/0xb0
> >  ...
> 
> So why don't you fix the root cause and add such a crap into the probe
> function (not even counting probe can fail later)?
> 
> Fix the virtio bus instead.

Incoherent? CHECK
Rude to bug reporter? CHECK
Unhelpful? CHECK

Wow, you must be a *great* kernel maintainer!

Thanks for making us all so very, very proud.
Rusty.
