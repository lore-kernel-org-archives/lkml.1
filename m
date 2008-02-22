Return-Path: <linux-kernel-owner+w=401wt.eu-S935740AbYBVKL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935740AbYBVKL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 05:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757192AbYBVKLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 05:11:32 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56392 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752425AbYBVKLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 05:11:31 -0500
Date: Fri, 22 Feb 2008 10:02:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@osdl.org, jeff@garzik.org
Subject: Re: GAK!!!! Re: PCI: AMD SATA IDE mode quirk
Message-ID: <20080222100205.5c86d351@core>
In-Reply-To: <20080222094828.2a0124ca@core>
References: <200802220059.m1M0xgjZ022717@hera.kernel.org>
	<20080222094828.2a0124ca@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 09:48:28 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> >     Signed-off-by: Crane Cai <crane.cai@amd.com>
> >     Acked-by: Jeff Garzik <jeff@garzik.org>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Vomitted-upon-by: Alan Cox <alan@redhat.com>
> 
> > -	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
> > -		u8 tmp;
> > +	/* set sb600/sb700/sb800 sata to ahci mode */
> > +	u8 tmp;
> >  
> > +	pci_read_config_byte(pdev, PCI_CLASS_DEVICE, &tmp);
> > +	if (tmp == 0x01) {
> 
> CLASS_DEVICE is cached in pdev->class so why not simply do:
> 
> 	if (pdev->class & (1 << 8))

or better yet

	((pdev->class & 0xFF00) == 0x0100)

;)
--
Gnome #3319
