Return-Path: <linux-kernel-owner+w=401wt.eu-S1764254AbZAOLAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764254AbZAOLAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762765AbZAOLAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:00:34 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:21958 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbZAOLAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:00:33 -0500
Date: Thu, 15 Jan 2009 12:00:25 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_MFD_PCF50633=m breaks the kernel build
Message-ID: <20090115120025.76a28b23@hyperion.delvare>
In-Reply-To: <20090115103112.GC3199@fedora.yogi>
References: <20090115100653.509416fb@hyperion.delvare>
	<20090115091107.GB3199@fedora.yogi>
	<20090115110955.4a8e9c5b@hyperion.delvare>
	<20090115103112.GC3199@fedora.yogi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 16:01:13 +0530, Balaji Rao wrote:
> On Thu, Jan 15, 2009 at 11:09:55AM +0100, Jean Delvare wrote:
> > On Thu, 15 Jan 2009 14:41:08 +0530, Balaji Rao wrote:
> > > On Thu, Jan 15, 2009 at 10:06:53AM +0100, Jean Delvare wrote:
> > > > Hi Balaji,
> > > > 
> > > > Building kernel 2.6.29-rc1-git4 on x86_64 with CONFIG_MFD_PCF50633=m
> > > > fails at linking time with:
> > > > 
> > > > ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
> > > > ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!
> > > 
> > > Yes, I've seen this. The fix is waiting on linux-mfd to be pulled
> > > anytime soon.
> > 
> > Where is linux-mfd? And what is it, a git tree, a mailing list? I
> > couldn't find any reference.
> 
> It's a git tree at http://git.o-hand.com/cgit.cgi/linux-mfd/

Would you be so kind and write a patch adding this information to
MAINTAINERS? And get it upstream, so that developers know where it is.

> > Can you please send me the patch now, so that I can fix my build
> > locally right now?
> 
>     pcf50633: Remove references to non-exported functions
>     
>     Remove references to set_irq_type and handle_level_irq which are not
>     exported to modules.
>     
>     Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> 
> diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
> index 24508e2..ea9488e 100644
> --- a/drivers/mfd/pcf50633-core.c
> +++ b/drivers/mfd/pcf50633-core.c
> @@ -626,7 +626,6 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
>  	}
>  
>  	if (client->irq) {
> -		set_irq_handler(client->irq, handle_level_irq);
>  		ret = request_irq(client->irq, pcf50633_irq,
>  				IRQF_TRIGGER_LOW, "pcf50633", pcf);
>  

Great, thanks! Now I can go on with my work.

-- 
Jean Delvare
