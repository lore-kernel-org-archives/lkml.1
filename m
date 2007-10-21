Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbXJUJBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbXJUJBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 05:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbXJUJBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 05:01:45 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:36812 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbXJUJBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 05:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TK0KGxfRfomdgrfUbUX2Y6WSrK+9wsuj1C/oCnyzgpSqCZ3E99RENhXuVbrZ+L5LRvicCzqyT8/vUrEJBnr3zGrSnBp7482yaYQvmHoGTiDBevNFsrNntu2sNMPxn7d5zjtTKZxIUmwcqJzp3m5s/c17FUYbYL9CFe8nSXdlrYc=
Message-ID: <471B1573.8000501@gmail.com>
Date: Sun, 21 Oct 2007 11:01:39 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/17] drivers/char/riscom8: irq handler cleanups
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org> <20071021075225.A1F9819041C@havoc.gtf.org>
In-Reply-To: <20071021075225.A1F9819041C@havoc.gtf.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2007 09:52 AM, Jeff Garzik wrote:
> commit 93ea6d56f83b7b614c103222fa098cb30d26f608
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Fri Oct 19 16:41:23 2007 -0400
> 
>     drivers/char/riscom8: irq handler cleanups
>     
>     No need to lookup board ptr, we already have it.
>     
>     Also, remove a few 'inline' markers and let the compiler make that
>     decision.
>     
>     Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Acked-by: Jiri Slaby <jirislaby@gmail.com>

> 
>  drivers/char/riscom8.c |   12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> 93ea6d56f83b7b614c103222fa098cb30d26f608
> diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
> index b37e626..d307320 100644
> --- a/drivers/char/riscom8.c
> +++ b/drivers/char/riscom8.c
> @@ -537,16 +537,14 @@ static inline void rc_check_modem(struct riscom_board const * bp)
>  }
>  
>  /* The main interrupt processing routine */
> -static irqreturn_t rc_interrupt(int irq, void * dev_id)
> +static irqreturn_t rc_interrupt(int dummy, void * dev_id)
>  {
>  	unsigned char status;
>  	unsigned char ack;
> -	struct riscom_board *bp;
> +	struct riscom_board *bp = dev_id;
>  	unsigned long loop = 0;
>  	int handled = 0;
>  
> -	bp = IRQ_to_board[irq];
> -

Remove the declaration of the IRQ_to_board too, since we don't reference it
anymore, we only set it up.

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
