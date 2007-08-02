Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbXHBIAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbXHBIAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 04:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbXHBH7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 03:59:55 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:52874 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbXHBH7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 03:59:55 -0400
Date: Thu, 2 Aug 2007 16:59:22 +0900
From: Mattia Dongili <malattia@linux.it>
To: Thomas Renninger <trenn@suse.de>
Cc: Eugene Teo <eugeneteo@kernel.sg>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/sonypi.c: fix ids member of struct
	acpi_driver
Message-ID: <20070802075921.GJ25969@inferi.kami.home>
References: <20070801091534.GA6845@kernel.sg> <20070802064034.GF25969@inferi.kami.home> <1186041019.18821.399.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186041019.18821.399.camel@queen.suse.de>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.23-rc1-mm1-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 09:50:18AM +0200, Thomas Renninger wrote:
> On Thu, 2007-08-02 at 15:40 +0900, Mattia Dongili wrote:
> > On Wed, Aug 01, 2007 at 05:15:34PM +0800, Eugene Teo wrote:
> > > ids member of struct acpi_driver is of type struct acpi_device_id, not a
> > > character array.
> > > 
> > > Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> > > ---
> > >  drivers/char/sonypi.c |    8 +++++++-
> > >  1 files changed, 7 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
> > > index 73037a4..ac0aeb0 100644
> > > --- a/drivers/char/sonypi.c
> > > +++ b/drivers/char/sonypi.c
> > > @@ -1147,10 +1147,16 @@ static int sonypi_acpi_remove(struct acpi_device *device, int type)
> > >  	return 0;
> > >  }
> > >  
> > > +const static struct acpi_device_id sonypi_device_ids[] = {
> > > +	{"SNY6001", 0},
> > > +	{"", 0},
> > > +};
> > > +MODULE_DEVICE_TABLE(acpi, sonypi_device_ids);
> > 
> > how does it behave with the already existing id in sony-laptop?
> > I'd rather avoid the MODULE_DEVICE_TABLE for sonypi allowing sony-laptop
> > to take over automagically.
> 
> Yes, sounds reasonable.
> The patch is needed, but MODULE_DEVICE_TABLE should be ripped out.
> AFAIK sonypi and sony-laptop cannot coexist together. But sony-acpi
> should be preferred. If someone needs sonypi, he needs to blacklist
> sony-apci in modprobe.conf and load sonypi manually.

Yes, that's what I meant.

> Shouldn't sony-acpi replace sonypi on longterm or at least addtional
> "SNY6001" functionality be merged to sony-acpi? Having two drivers for
> the same device is not a good idea.

yep, sony-laptop will replace sonypi. It still has some problems but
development is progressing in sony-laptop, not sonypi.

Eugene, I'll import the patch without the MODULE_DEVICE_TABLE line.
cheers
-- 
mattia
:wq!
