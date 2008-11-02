Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYKBOH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYKBOH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 09:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYKBOHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 09:07:50 -0500
Received: from isilmar.linta.de ([213.133.102.198]:35856 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753341AbYKBOHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 09:07:50 -0500
Date: Sun, 2 Nov 2008 15:07:48 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: pcmcia: struct device - replace bus_id with dev_name(), dev_set_name()
Message-ID: <20081102140748.GA6399@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Kay Sievers <kay.sievers@vrfy.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Greg KH <greg@kroah.com>
References: <1225536366.13224.2.camel@nga.site> <20081102121320.GA15349@comet.dominikbrodowski.net> <ac3eb2510811020555r417a3b10xbadc9d87b0c3ea0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510811020555r417a3b10xbadc9d87b0c3ea0a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay,

On Sun, Nov 02, 2008 at 02:55:46PM +0100, Kay Sievers wrote:
> On Sun, Nov 2, 2008 at 13:13, Dominik Brodowski
> <linux@dominikbrodowski.net> wrote:
> > On Sat, Nov 01, 2008 at 11:46:06AM +0100, Kay Sievers wrote:
> >> From: Kay Sievers <kay.sievers@vrfy.org>
> >> Subject: pcmcia: struct device - replace bus_id with dev_name(), dev_set_name()
> >>
> >> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> >> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> >> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
> >
> > is this to go in via -pcmcia or via -driver-core?
> 
> Would be great if this goes through -pcmcia, and show up in -next
> soon,

it's in -pcmcia now.

> >> diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
> >> index c68c5d3..5d0e60e 100644
> >> --- a/drivers/pcmcia/cs.c
> >> +++ b/drivers/pcmcia/cs.c
> >> @@ -226,7 +226,7 @@ int pcmcia_register_socket(struct pcmcia_socket *socket)
> >>       /* set proper values in socket->dev */
> >>       dev_set_drvdata(&socket->dev, socket);
> >>       socket->dev.class = &pcmcia_socket_class;
> >> -     snprintf(socket->dev.bus_id, BUS_ID_SIZE, "pcmcia_socket%u", socket->sock);
> >> +     dev_set_name(&socket->dev, "pcmcia_socket%u", socket->sock);
> >
> > In other places, you check for !dev_name() afterwards -- why not here?
> 
> The name is used in the line just below setting it, which is why we
> need to check that it is not NULL. The other case, like in almost all
> other cases, the unlikely event of failing to set the name is handled
> by a failing call to device_register().

Ah, okay. Thanks.

	Dominik
