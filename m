Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYJPXMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYJPXMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbYJPXMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:12:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756250AbYJPXMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:12:08 -0400
Date: Thu, 16 Oct 2008 16:11:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dean Nelson <dcn@sgi.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] NULL struct irq_desc's member 'name' in
 dynamic_irq_cleanup()
Message-Id: <20081016161145.58bbe635.akpm@linux-foundation.org>
In-Reply-To: <20081016125808.GA24347@sgi.com>
References: <20081016125808.GA24347@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 07:58:08 -0500
Dean Nelson <dcn@sgi.com> wrote:

> If the member 'name' of the irq_desc structure happens to point to a character
> string that is resident within a kernel module, problems insue if that module
> is rmmod'd (at which time dynamic_irq_cleanup() is called) and then later
> show_interrupts() is called by someone.

It would be nice to spell out what the "problems" are.

> It is also not a good thing if the
> character string resided in kmalloc'd space that has been kfree'd (after
> having called dynamic_irq_cleanup()). dynamic_irq_cleanup() fails to NULL
> the 'name' member and show_interrupts() references it on a few architectures
> (like h8300, sh and x86).
> 
> Signed-off-by: Dean Nelson <dcn@sgi.com>
> 
> ---
> 
>  kernel/irq/chip.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux/kernel/irq/chip.c
> ===================================================================
> --- linux.orig/kernel/irq/chip.c	2008-10-15 07:44:31.000000000 -0500
> +++ linux/kernel/irq/chip.c	2008-10-16 06:55:56.000000000 -0500
> @@ -79,6 +79,7 @@ void dynamic_irq_cleanup(unsigned int ir
>  	desc->chip_data = NULL;
>  	desc->handle_irq = handle_bad_irq;
>  	desc->chip = &no_irq_chip;
> +	desc->name = NULL;
>  	spin_unlock_irqrestore(&desc->lock, flags);
>  }
>  

Because we should work out whether this should be backported into
-stable.  And if so, how far back it should go.

