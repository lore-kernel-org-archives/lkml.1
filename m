Return-Path: <linux-kernel-owner+w=401wt.eu-S1762273AbXF0Uhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762273AbXF0Uhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 16:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbXF0Uhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 16:37:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55949 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbXF0Uhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 16:37:35 -0400
Date: Wed, 27 Jun 2007 13:37:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] balance parenthesis in serial core
Message-Id: <20070627133717.d19d82c9.akpm@linux-foundation.org>
In-Reply-To: <200706272222.01300.m.kozlowski@tuxland.pl>
References: <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
	<200706272222.01300.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 22:22:00 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	This patch balances the parenthesis imbalance in serial core.
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/serial/serial_core.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.22-rc6-bo-a/drivers/serial/serial_core.c	2007-06-27 22:05:41.000000000 +0200
> +++ linux-2.6.22-rc6-bo-b/drivers/serial/serial_core.c	2007-06-27 22:08:56.000000000 +0200
> @@ -1158,9 +1158,9 @@ static void uart_set_termios(struct tty_
>  	 * appropriately by set_termios() in tty_ioctl.c
>  	 */
>  #ifdef CIBAUD
> -#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD)
> +#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD))
>  #else
> -#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD)
> +#define RELEVANT_CFLAG(cflag)	((cflag) & ~(CIBAUD|CBAUD))
>  #endif
>  #define RELEVANT_IFLAG(iflag)	((iflag) & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
>  	if ((cflag ^ old_termios->c_cflag) == 0 &&

Thanks.  so...  why shouldn't we just remove the buggy&&unused RELEVANT_CFLAG
defines??
