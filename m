Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbYLENRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbYLENRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYLENRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:17:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:5689 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbYLENRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:17:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kiWyCokRR79bVIcbnf3J2HIg9mFLh0KSPPtgB+vbbuRQxn/ZTpLKywUV24G6jfchPZ
         gF3IsfnvioYclIB2KaDMM34CyNug6Zcq7m5NW3Z46frZ+rvFpXvkjPB43lpr5TXGOnV2
         bm8mDq9szT1VAy3nYzJl3TjuaU8U164ZfUgIk=
Message-ID: <493929D2.4070900@gmail.com>
Date: Fri, 05 Dec 2008 14:17:06 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Mark McLoughlin <markmc@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
References: <1228394671.3732.77.camel@blaa> <49385DB7.4060306@gmail.com> <4938EE0B.8020501@msgid.tls.msk.ru>
In-Reply-To: <4938EE0B.8020501@msgid.tls.msk.ru>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev napsal(a):
> Jiri Slaby wrote:
>> On 12/04/2008 01:44 PM, Mark McLoughlin wrote:
>>> Nothing takes a ref on virtio_pci, so even if you have
>>> devices in use, rmmod will attempt to unload the module.
>> It unbinds the device properly as any other driver. So what's the problem here?
> 
> Here's what we get when rmmod'ing (a zero-refcounted but
> in use) virtio_pci (I did it by a chance, cut-n-pasted
> the wrong line):
> 
> WARNING: at drivers/base/core.c:122 device_release+0x5f/0x70()
> Device 'virtio1' does not have a release() function, it is broken and must be fixed.
> Modules linked in: ext3 jbd mbcache acpiphp dock pci_hotplug virtio_net virtio_blk virtio_pci(-) virtio_ring virtio
> 
> Pid: 361, comm: rmmod Tainted: G S        2.6.27-i686smp #2.6.27.7
>  [<c012b81f>] warn_slowpath+0x6f/0xa0
>  [<c0110030>] prepare_set+0x30/0x80
>  [<c012067e>] __wake_up+0x3e/0x60
>  [<c01d1d25>] release_sysfs_dirent+0x45/0xb0
>  ...

So why don't you fix the root cause and add such a crap into the probe
function (not even counting probe can fail later)?

Fix the virtio bus instead.
