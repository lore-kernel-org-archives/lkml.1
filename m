Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbYLGIW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbYLGIW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 03:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbYLGIWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 03:22:20 -0500
Received: from ozlabs.org ([203.10.76.45]:56745 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbYLGIWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 03:22:19 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH] virtio: make PCI devices take a virtio_pci module ref
Date: Sun, 7 Dec 2008 18:52:08 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
       Anthony Liguori <aliguori@us.ibm.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <1228394671.3732.77.camel@blaa> <200812051043.51417.rusty@rustcorp.com.au> <1228489626.3858.37.camel@blaa>
In-Reply-To: <1228489626.3858.37.camel@blaa>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812071852.08962.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2008 01:37:06 Mark McLoughlin wrote:
> Another example of a lack of an explicit dependency causing problems is
> Fedora's mkinitrd having this hack:
> 
>     if echo $PWD | grep -q /virtio-pci/ ; then
>         findmodule virtio_pci
>     fi
>
> which basically says "if this is a virtio device, don't forget to
> include virtio_pci in the initrd too!". Now, mkinitrd is full of hacks,
> but this is a particularly unusual one.

Um, I don't know what this does, sorry.

I have no idea how Fedora chooses what to put in an initrd; I can't think
of a sensible way of deciding what goes in and what doesn't other than
lists and heuristics.

But there really is no explicit dependency between virtio modules and
virtio_pci.  There just is for kvm/x86 at the moment, since that is how
they use virtio.  Running over another bus is certainly possible,
though may never happen for x86 (happens today for s390).

Cheers,
Rusty.
