Return-Path: <linux-kernel-owner+w=401wt.eu-S1760324AbXFFQwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324AbXFFQwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbXFFQv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:51:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbXFFQv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:51:57 -0400
Date: Wed, 6 Jun 2007 09:51:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070606095124.ae95529c.akpm@linux-foundation.org>
In-Reply-To: <46669CE6.6060804@googlemail.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<46669CE6.6060804@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 13:39:18 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:

> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
> >
> >   
> 
> 
> Compile error here :
> 
> ...
> 
> LD .tmp_vmlinux1
> drivers/built-in.o: In function `acpi_init':
> bus.c:(.init.text+0x249a): undefined reference to `pci_mmcfg_late_init'
> make: *** [.tmp_vmlinux1] Error 1
> 
> ....
> 
> 
> http://frugalware.org/~crazy/other/mm/2.6.22-rc4-mm1/config
> 

Yeah, this caused test.kernel.org to fail as well.

There are a couple of fixes in
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/hot-fixes/
which should get things going again.

Robert, I spent some time picking at
mmconfig-validate-against-acpi-motherboard-resources.patch then got bored
with fiddling with it and reverted it outright.

Please, we need to get those prototypes of pci_mmcfg_early_init() and
pci_mmcfg_late_init() into some sane place which works on all
architectures, not duplicate one of them in a C file and even see if we can
avoid the #ifdef CONFIG_PCI_MMCONFIG in arch/i386/pci/init.c

This code area is really messy, due partly to the x86_64 and i386 sharing. 
Any changes in there need careful testing and checking.

