Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbZAML3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbZAML3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 06:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZAML3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 06:29:46 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:39465 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbZAML3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 06:29:45 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 1/4] hvc_console: do not set low_latency
Date: Tue, 13 Jan 2009 12:28:41 +0100
User-Agent: KMail/1.9.9
Cc: Benjiman Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, Joe Peterson <joe@skyrush.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <hvc-console-29-3-1@bga.com> <200901131004.22609.borntraeger@de.ibm.com>
In-Reply-To: <200901131004.22609.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131228.41189.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 13 Januar 2009 schrieb Christian Borntraeger:
>  drivers/char/hvc_console.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/char/hvc_console.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/hvc_console.c
> +++ linux-2.6/drivers/char/hvc_console.c
> @@ -318,8 +318,6 @@ static int hvc_open(struct tty_struct *t
>  	} /* else count == 0 */
> 
>  	tty->driver_data = hp;
> -	tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
> -
>  	hp->tty = tty;
> 
>  	spin_unlock_irqrestore(&hp->lock, flags);
> @@ -327,6 +325,9 @@ static int hvc_open(struct tty_struct *t
>  	if (hp->ops->notifier_add)
>  		rc = hp->ops->notifier_add(hp, hp->data);
> 
> +	if (!hp->irq_requested)
> +		tty->low_latency = 1; /* Makes flushes to ldisc synchronous. */
> +
>  	/*
>  	 * If the notifier fails we return an error.  The tty layer
>  	 * will call hvc_close() after a failed open but we don't want to clean
> 
> 

Just in case:

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
