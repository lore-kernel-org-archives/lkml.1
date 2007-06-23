Return-Path: <linux-kernel-owner+w=401wt.eu-S1760670AbXFWQwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670AbXFWQwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759856AbXFWQwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:52:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52761 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759699AbXFWQwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:52:05 -0400
Date: Sat, 23 Jun 2007 09:51:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mark A. Greer" <mgreer@mvista.com>
Cc: linux-kernel@vger.kernel.org, jaylubo@motorola.com
Subject: Re: [PATCH] serial: Clear proper MPSC interrupt cause bits
Message-Id: <20070623095144.0ec7e8c6.akpm@linux-foundation.org>
In-Reply-To: <20070622023208.GA20651@mag.az.mvista.com>
References: <20070622023208.GA20651@mag.az.mvista.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 21 Jun 2007 19:32:08 -0700 "Mark A. Greer" <mgreer@mvista.com> wrote:
> From: Jay Lubomirski <jaylubo@motorola.com>
> 
> Don't clobber the interrupt cause bits for both MPSC controllers when
> clearing the interrupt for one of them.  Just clear the one that is
> supposed to be cleared.
> 
> Signed-off-by: Jay Lubomirski <jaylubo@motorola.com>
> Acked-by: Mark A. Greer <mgreer@mvista.com>
> ---
>  drivers/serial/mpsc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
> index d09f209..00924fe 100644
> --- a/drivers/serial/mpsc.c
> +++ b/drivers/serial/mpsc.c
> @@ -503,7 +503,8 @@ mpsc_sdma_intr_ack(struct mpsc_port_info *pi)
>  
>  	if (pi->mirror_regs)
>  		pi->shared_regs->SDMA_INTR_CAUSE_m = 0;
> -	writel(0, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE);
> +	writeb(0x00, pi->shared_regs->sdma_intr_base + SDMA_INTR_CAUSE +
> +	       pi->port.line);
>  	return;
>  }

In my naive little mpscless bubbleworld, I am believing that this is a
pretty important fix, and that people in an mpscful world might want it in
2.6.22.  And even in 2.6.21.x.

But alas, that's just a guess, which was forced upon me by the lack of
suitable information in your changelog.

So please, tell us what are the real-world consequences of your patch (or
the lack of it), thanks.
