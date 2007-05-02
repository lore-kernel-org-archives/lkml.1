Return-Path: <linux-kernel-owner+w=401wt.eu-S1161759AbXEBVHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161759AbXEBVHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161764AbXEBVHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:07:00 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53869 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161759AbXEBVG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:06:59 -0400
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
From: john stultz <johnstul@us.ibm.com>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
In-Reply-To: <20070502193314.GA23367@enneenne.com>
References: <20070321074121.GA13843@enneenne.com>
	 <20070502193314.GA23367@enneenne.com>
Content-Type: text/plain
Date: Wed, 02 May 2007 14:06:53 -0700
Message-Id: <1178140014.7338.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-02 at 21:33 +0200, Rodolfo Giometti wrote:
> Pulse per Second (PPS) support for Linux.
> 
> Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>
> 
> ---
> 
> Here my last release of PPS support for Linux.
> 
> The difference against my last patch is about all userland specific
> code (timepps.h) which has been removed, I hope now you can consider
> adding it into kernel source tree!
> 
> Please, let me know if I still should fix something else.

Please inline your patch, rather then attaching them. It makes it very
difficult to discuss when it is attached.


> diff --git a/drivers/pps/clients/ktimer.c b/drivers/pps/clients/ktimer.c
> new file mode 100644
> index 0000000..7514389
> --- /dev/null
> +++ b/drivers/pps/clients/ktimer.c
> @@ -0,0 +1,106 @@
> +/*
> + * ktimer.c -- kernel timer test client
> + *

Could you use a better name, like pps_ktimer_test.c, so it is less generic?

Same goes for your kabi.c and sysfs.c files.


> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 98ec861..543c7cb 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -2004,6 +2004,8 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
>  		up->ier |= UART_IER_MSI;
>  	if (up->capabilities & UART_CAP_UUE)
>  		up->ier |= UART_IER_UUE | UART_IER_RTOIE;
> +	if (up->port.flags & UPF_HARDPPS_CD)
> +		up->ier |= UART_IER_MSI;	/* enable interrupts */
> 

This isn't covered by a #ifdef, so is this always safe? Should it be in
a separate patch?

Unfortunately I don't have any hardware to play with this, but I'd
suggest you send this to Andrew Morton for inclusion into his tree for
testing.

thanks
-john

