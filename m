Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbZKQQ4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbZKQQ4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZKQQ4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:56:52 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54548 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751267AbZKQQ4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:56:51 -0500
Date: Tue, 17 Nov 2009 16:58:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] gpio_addr_flash: Fix warnings
Message-ID: <20091117165844.0fb043f3@lxorguk.ukuu.org.uk>
In-Reply-To: <8bd0f97a0911170850x40f68e02y5a3d8ad39c4f9b90@mail.gmail.com>
References: <20091117154641.3879.73168.stgit@localhost.localdomain>
	<8bd0f97a0911170850x40f68e02y5a3d8ad39c4f9b90@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 11:50:24 -0500
Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Tue, Nov 17, 2009 at 10:46, Alan Cox wrote:
> > --- a/drivers/mtd/maps/gpio-addr-flash.c
> > +++ b/drivers/mtd/maps/gpio-addr-flash.c
> > -       state->gpio_addrs     = (void *)gpios->start;
> > +       state->gpio_addrs     = (void *)(unsigned long)gpios->start;
> > -       state->map.virt       = (void __iomem *)memory->start;
> > +       state->map.virt       = (void __iomem *)(unsigned long)memory->start;
> 
> on what system do you see warnings ?  start should be resource_size_t
> which should be phys_addr_t which should cast fine to a void*.

32bit x86 shows it up because resource_size_t is a physaddr_t which is
64bit (because of PAE). Now given you don't seem likely to be using the
top bits for any real world example that looks ok but really casting a
physical address to a pointer type needs care and the compiler can't
deduce your intent there.


