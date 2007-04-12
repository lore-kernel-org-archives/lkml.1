Return-Path: <linux-kernel-owner+w=401wt.eu-S2992490AbXDLLGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992490AbXDLLGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 07:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992499AbXDLLGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 07:06:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43706 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992490AbXDLLGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 07:06:38 -0400
Date: Thu, 12 Apr 2007 12:06:37 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: initramfs unpack point and rules
Message-ID: <20070412110637.GG4095@ftp.linux.org.uk>
References: <m3ejmzdmow.fsf@maximus.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3ejmzdmow.fsf@maximus.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 02:34:39PM +0200, Krzysztof Halasa wrote:
> First problem: initramfs is unpacked way before console drivers
> are initialized, so you aren't going to see the panic():
> 
> init/initramfs.c:static int __init populate_rootfs(void)
> ...
> 		printk(KERN_INFO "Unpacking initramfs...");
> 		err = unpack_to_rootfs((char *)initrd_start,
> 			initrd_end - initrd_start, 0);
> 		if (err)
> 			panic(err);
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 		printk(" done\n");
> 		free_initrd();
> 
> I wonder why is initramfs unpacked that early, before most drivers?
> I'd expect it much later in the boot sequence, just before userspace
> and initial devices (/dev/console etc) are needed. Should it be moved
> there? populate_rootfs() unpacks both builtin and external initramfs.

Nope.  The point is to have it as early as possible, so that we had more
or less normal environment when drivers, etc. are being initialized.
