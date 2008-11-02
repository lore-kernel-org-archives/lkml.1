Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbYKBNgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbYKBNgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 08:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYKBNgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 08:36:45 -0500
Received: from isilmar.linta.de ([213.133.102.198]:54575 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753260AbYKBNgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 08:36:44 -0500
Date: Sun, 2 Nov 2008 13:13:20 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: pcmcia: struct device - replace bus_id with dev_name(),
	dev_set_name()
Message-ID: <20081102121320.GA15349@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Kay Sievers <kay.sievers@vrfy.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>
References: <1225536366.13224.2.camel@nga.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225536366.13224.2.camel@nga.site>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Nov 01, 2008 at 11:46:06AM +0100, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: pcmcia: struct device - replace bus_id with dev_name(), dev_set_name()
> 
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>

is this to go in via -pcmcia or via -driver-core?

> diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
> index c68c5d3..5d0e60e 100644
> --- a/drivers/pcmcia/cs.c
> +++ b/drivers/pcmcia/cs.c
> @@ -226,7 +226,7 @@ int pcmcia_register_socket(struct pcmcia_socket *socket)
>  	/* set proper values in socket->dev */
>  	dev_set_drvdata(&socket->dev, socket);
>  	socket->dev.class = &pcmcia_socket_class;
> -	snprintf(socket->dev.bus_id, BUS_ID_SIZE, "pcmcia_socket%u", socket->sock);
> +	dev_set_name(&socket->dev, "pcmcia_socket%u", socket->sock);

In other places, you check for !dev_name() afterwards -- why not here?

Otherwise it is

Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>

Thanks!
	Dominik
