Return-Path: <linux-kernel-owner+w=401wt.eu-S1763259AbYAKXLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763259AbYAKXLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 18:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758179AbYAKXLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 18:11:00 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:33212 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755585AbYAKXLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 18:11:00 -0500
Subject: Re: [PATCH] 8390: split up 8390 with ISA delay and 8390 without
From: Zachary Amsden <zach@vmware.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080111180848.10a7f012@lxorguk.ukuu.org.uk>
References: <20080111180848.10a7f012@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Fri, 11 Jan 2008 15:16:31 -0800
Message-Id: <1200093391.21817.27.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-11 at 18:08 +0000, Alan Cox wrote:
> This lets us remove port 0x80 use on the PCI systems. It also speeds
> up
> some of the later 8390 based cores where we know the device does not
> need
> delay loops either because it has internal handling or in most cases a
> faster device anyway.
> 
> We compile up a new module 8390p to go with 8390 one with delays and
> one
> without. Most users will never need 8390p so it seems best to produce
> two
> modules.

> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/net/hp.c linux-2.6.24-rc6-mm1/drivers/net/hp.c
> --- linux.vanilla-2.6.24-rc6-mm1/drivers/net/hp.c	2008-01-02 16:04:00.000000000 +0000
> +++ linux-2.6.24-rc6-mm1/drivers/net/hp.c	2008-01-11 14:47:44.000000000 +0000

> @@ -176,7 +176,7 @@
>  				outb_p(irqmap[irq] | HP_RUN, ioaddr + HP_CONFIGURE);
>  				outb_p( 0x00 | HP_RUN, ioaddr + HP_CONFIGURE);

... didn't you miss two here?  Otherwise, code looks great.

How will the user know when they need to use 8390p?  Should you perhaps default to producing and using 8390p if CONFIG_ISA is on?

Zach

