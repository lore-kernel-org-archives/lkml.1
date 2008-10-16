Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbYJPVrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbYJPVrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYJPVrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:47:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755172AbYJPVrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:47:14 -0400
Date: Thu, 16 Oct 2008 14:46:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: davem@davemloft.net, alan@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: Make uart_port's ioport "resource_size_t"
Message-Id: <20081016144645.1c868fc0.akpm@linux-foundation.org>
In-Reply-To: <20081014162621.GA18166@yoda.jdub.homelinux.org>
References: <20081014162621.GA18166@yoda.jdub.homelinux.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 12:26:21 -0400
Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:

> Recently uart_port's iobase was changed to be an 'unsigned
> long' to avoid chopping off the upper 32-bits of the
> address on 64-bit CPUs.  However, there are CPUs that are
> 32-bit but have a 64-bit address space.  This changes
> iobase to be 'resource_size_t' to accommodate those types
> of systems.  This also matches what is done for the mapbase
> member of uart_port.
> 
> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> 
> ---
> 
> diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> index e27f216..cb0185b 100644
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -241,7 +241,7 @@ typedef unsigned int __bitwise__ upf_t;
>  
>  struct uart_port {
>  	spinlock_t		lock;			/* port lock */
> -	unsigned long		iobase;			/* in/out[bwl] */
> +	resource_size_t		iobase;			/* in/out[bwl] */
>  	unsigned char __iomem	*membase;		/* read/write[bwl] */
>  	unsigned int		irq;			/* irq number */
>  	unsigned int		uartclk;		/* base uart clock */

This will of course require that all now-broken printk()s be unbroken. 
I spot two in serial_core.c alone.

