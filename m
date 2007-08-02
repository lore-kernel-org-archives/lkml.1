Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbXHBHuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbXHBHuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 03:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXHBHuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 03:50:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbXHBHuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 03:50:22 -0400
Subject: Re: [PATCH] drivers/char/sonypi.c: fix ids member of struct
	acpi_driver
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Mattia Dongili <malattia@linux.it>
Cc: Eugene Teo <eugeneteo@kernel.sg>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070802064034.GF25969@inferi.kami.home>
References: <20070801091534.GA6845@kernel.sg>
	 <20070802064034.GF25969@inferi.kami.home>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 02 Aug 2007 09:50:18 +0200
Message-Id: <1186041019.18821.399.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 15:40 +0900, Mattia Dongili wrote:
> On Wed, Aug 01, 2007 at 05:15:34PM +0800, Eugene Teo wrote:
> > ids member of struct acpi_driver is of type struct acpi_device_id, not a
> > character array.
> > 
> > Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> > ---
> >  drivers/char/sonypi.c |    8 +++++++-
> >  1 files changed, 7 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
> > index 73037a4..ac0aeb0 100644
> > --- a/drivers/char/sonypi.c
> > +++ b/drivers/char/sonypi.c
> > @@ -1147,10 +1147,16 @@ static int sonypi_acpi_remove(struct acpi_device *device, int type)
> >  	return 0;
> >  }
> >  
> > +const static struct acpi_device_id sonypi_device_ids[] = {
> > +	{"SNY6001", 0},
> > +	{"", 0},
> > +};
> > +MODULE_DEVICE_TABLE(acpi, sonypi_device_ids);
> 
> how does it behave with the already existing id in sony-laptop?
> I'd rather avoid the MODULE_DEVICE_TABLE for sonypi allowing sony-laptop
> to take over automagically.

Yes, sounds reasonable.
The patch is needed, but MODULE_DEVICE_TABLE should be ripped out.
AFAIK sonypi and sony-laptop cannot coexist together. But sony-acpi
should be preferred. If someone needs sonypi, he needs to blacklist
sony-apci in modprobe.conf and load sonypi manually.

Shouldn't sony-acpi replace sonypi on longterm or at least addtional
"SNY6001" functionality be merged to sony-acpi? Having two drivers for
the same device is not a good idea.

Thanks,

   Thomas

