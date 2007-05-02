Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbXEBUs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbXEBUs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbXEBUs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:48:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:12090 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbXEBUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:48:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VyO3MKh0JRF6nkalpvk5JbdT04BMDBrQLqB6O7XHWloYpYYBsMwFVPphNbXoah2v0FtYFYIGUd7R699InI0Q4LwHXdHeFrD8s9TXV58UTuHPDl0Y1Vl9rM8iFHe8xLDOt5xKFnF37Dlw7zyQ7UuiUM7OG02V8Zh/Pn6Q68PqVGc=
Message-ID: <b3ece790705021348j7a0c7037u221a1f5b5dae4838@mail.gmail.com>
Date: Wed, 2 May 2007 13:48:55 -0700
From: "Tim Hockin" <thockin@hockin.org>
To: "Rafal Bilski" <rafalbilski@interia.pl>
Subject: Re: Natsemi DP83815 driver spaming
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Mark Brown" <broonie@sirena.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <4638EF0B.9050701@interia.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070501084639.GA528@sirena.org.uk>
	 <20070501212750.GC31630@sirena.org.uk>
	 <b3ece790705011543gdca3a9ei905d3499b6c18dc8@mail.gmail.com>
	 <46382798.2090709@interia.pl>
	 <b3ece790705012303x1e5a2d03xddf6c14aec5a99d8@mail.gmail.com>
	 <463830E1.8080107@interia.pl>
	 <b3ece790705012351g5c0ff8a6g9f2f350ff86f3319@mail.gmail.com>
	 <20070502082211.GD31630@sirena.org.uk>
	 <b3ece790705020744p2e73bb5fo2c0acad947a5de15@mail.gmail.com>
	 <4638EF0B.9050701@interia.pl>
X-Google-Sender-Auth: e51a600fdfe79f6c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Rafal Bilski <rafalbilski@interia.pl> wrote:

> What about module option?

Looks ok to me, if this is the preferred route.

> ---
>  drivers/net/natsemi.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
> index 349b96a..933e106 100644
> --- a/drivers/net/natsemi.c
> +++ b/drivers/net/natsemi.c
> @@ -90,6 +90,10 @@ static int rx_copybreak;
>  static int options[MAX_UNITS];
>  static int full_duplex[MAX_UNITS];
>
> +/* Used to disable "is PHY alive" check for compatibility with broken
> + * designs using rev. C chips. */
> +static int disable_phy_check;
> +
>  /* Operational parameters that are set at compile time. */
>
>  /* Keep the ring sizes a power of two for compile efficiency.
> @@ -141,6 +145,7 @@ module_param(debug, int, 0);
>  module_param(rx_copybreak, int, 0);
>  module_param_array(options, int, NULL, 0);
>  module_param_array(full_duplex, int, NULL, 0);
> +module_param(disable_phy_check, int, 0);
>  MODULE_PARM_DESC(mtu, "DP8381x MTU (all boards)");
>  MODULE_PARM_DESC(debug, "DP8381x default debug level");
>  MODULE_PARM_DESC(rx_copybreak,
> @@ -148,6 +153,8 @@ MODULE_PARM_DESC(rx_copybreak,
>  MODULE_PARM_DESC(options,
>         "DP8381x: Bits 0-3: media type, bit 17: full duplex");
>  MODULE_PARM_DESC(full_duplex, "DP8381x full duplex setting(s) (1)");
> +MODULE_PARM_DESC(disable_phy_check, "DP8381[56]: PHY lockup check disable"
> +       " (all boards)");
>
>  /*
>                                 Theory of Operation
> @@ -1753,7 +1760,7 @@ static void netdev_timer(unsigned long data)
>                 writew(1, ioaddr+PGSEL);
>                 dspcfg = readw(ioaddr+DSPCFG);
>                 writew(0, ioaddr+PGSEL);
> -               if (dspcfg != np->dspcfg) {
> +               if (!disable_phy_check && dspcfg != np->dspcfg) {
>                         if (!netif_queue_stopped(dev)) {
>                                 spin_unlock_irq(&np->lock);
>                                 if (netif_msg_hw(np))
> --
