Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZFVRGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZFVRGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbZFVRGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:06:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47179 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751901AbZFVRGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:06:05 -0400
Date: Mon, 22 Jun 2009 18:06:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Remove tty low_latency flag setting from drivers/char/
Message-ID: <20090622180650.1d5a6515@lxorguk.ukuu.org.uk>
In-Reply-To: <20090622123250.5c2cd13e@dhcp-100-2-144.bos.redhat.com>
References: <20090622123250.5c2cd13e@dhcp-100-2-144.bos.redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Remove tty low_latency flag setting from drivers/char/.
> 
> The kernel oopses if this flag is set.

ipwireless_network_packet_received is not called from an IRQ path but
from a sleeping one. Please provide a trace of whatever you see failing
with that one as it should be fine and that isn't a bug fix. It may or
may not need low_latency but something else is wrong if it matters.

> 
> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
> 
> --- linux-2.6.30.noarch.orig/drivers/char/nozomi.c
> +++ linux-2.6.30.noarch/drivers/char/nozomi.c
> @@ -1591,8 +1591,6 @@ static int ntty_open(struct tty_struct *
>  
>  	/* Enable interrupt downlink for channel */
>  	if (port->port.count == 1) {
> -		/* FIXME: is this needed now ? */
> -		tty->low_latency = 1;

This one is correct.

> --- linux-2.6.30.noarch.orig/drivers/char/mxser.c
> +++ linux-2.6.30.noarch/drivers/char/mxser.c
> @@ -1048,8 +1048,6 @@ static int mxser_open(struct tty_struct 
>  	if (retval)
>  		return retval;
>  
> -	/* unmark here for very high baud rate (ex. 921600 bps) used */
> -	tty->low_latency = 1;
>  	return 0;
>  }

As is this
