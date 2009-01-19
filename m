Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbZASOYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbZASOYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:24:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZASOXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:23:51 -0500
Received: from mail-bw0-f18.google.com ([209.85.218.18]:46946 "EHLO
	mail-bw0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZASOXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:23:49 -0500
X-Greylist: delayed 4828 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2009 09:23:48 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=IOu/N0Wvrfcxh7OlhWk8AybEjiZizTqB0h8mAmOuVqtJbO1vs4RRUYZDCNtJpOydIz
         PDozZ/T0gPUvT35T5t7b+lQ5IkY6aB0m+usxGXDbrV8dvT/AHPvmToHSRytKz/KNBncg
         S/9eXIjFWEspsG3sVTDeB3wKXphoKG91d5Kts=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 2/6] ide: move SFF I/O code to ide-io-sff.c
Date: Mon, 19 Jan 2009 15:23:15 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-next-20090116; KDE/4.1.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain> <20090119130322.24745.76137.sendpatchset@localhost.localdomain> <49748B95.9080105@ru.mvista.com>
In-Reply-To: <49748B95.9080105@ru.mvista.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901191523.15240.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
>     Gah, what in the world is that SFF I/O code?
> 
> > Index: b/drivers/ide/ide-io-sff.c
> > ===================================================================
> > --- /dev/null
> > +++ b/drivers/ide/ide-io-sff.c
> > @@ -0,0 +1,314 @@
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/ide.h>
> > +
> > +/*
> > + *	Conventional PIO operations for ATA devices
> > + */
> > +
> > +static u8 ide_inb(unsigned long port)
> > +{
> > +	return (u8) inb(port);
> > +}
> > +
> > +static void ide_outb(u8 val, unsigned long port)
> > +{
> > +	outb(val, port);
> > +}
> > +
> > +/*
> > + *	MMIO operations, typically used for SATA controllers
> > + */
> > +
> > +static u8 ide_mm_inb(unsigned long port)
> > +{
> > +	return (u8) readb((void __iomem *) port);
> > +}
> > +
> > +static void ide_mm_outb(u8 value, unsigned long port)
> > +{
> > +	writeb(value, (void __iomem *) port);
> > +}
> 
>     Ah, I see. Can we finally stop abusing the SFF name? Or are we bound to 
> copy every mistake that libata has made? :-/

Please suggest a better name. :)

[ I'm also not happy with the naming but couldn't think of a better one. ]
