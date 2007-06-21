Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbXFUERT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbXFUERT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbXFUERH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:17:07 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:62962 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbXFUERF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:17:05 -0400
Date: Thu, 21 Jun 2007 13:16:14 +0900
From: Mattia Dongili <malattia@linux.it>
To: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       acpi4asus-user <acpi4asus-user@lists.sourceforge.net>
Subject: Re: [PATCH 3/3] ACPI autoloading - Create __mod_acpi_device_table symbol for all acpi drivers.
Message-ID: <20070621041614.GA6433@inferi.kami.home>
References: <1182112047.4204.12.camel@noname> <1182111863.4204.6.camel@noname> <20070620170617.GA3226@inferi.kami.home> <1182361643.28514.708.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182361643.28514.708.camel@queen.suse.de>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc5-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 07:47:23PM +0200, Thomas Renninger wrote:
> On Thu, 2007-06-21 at 02:06 +0900, Mattia Dongili wrote:
> > On Sun, Jun 17, 2007 at 10:24:23PM +0200, Thomas Renninger wrote:
...
> > > +static const struct acpi_device_id sony_device_ids[] = {
> > > +	{SONY_NC_HID, 0},
> > > +	{SONY_PIC_HID, 0},
> > > +	{"", 0},
> > > +};
> > > +MODULE_DEVICE_TABLE(acpi, sony_device_ids);
> > > +
> > > +static const struct acpi_device_id sony_nc_device_ids[] = {
> > > +	{SONY_NC_HID, 0},
> > > +	{"", 0},
> > > +};
> > > +
> > ...
> > > +static const struct acpi_device_id sony_pic_device_ids[] = {
> > > +	{SONY_PIC_HID, 0},
> > > +	{"", 0},
> > > +};
> > > +
> > 
> > is it really necessary to have those duplicate entries?
> In this case, yes.
> 
> It's because two independent ACPI drivers are set up here.
> If you could put these together, only set up
> acpi_bus_register_driver(..) once in .init and get the pic and nc driver
> handled together it would work.
> 
> I don't know whether this could be done.

probably, I guess the the acpi_device.pnp structs contain enough
informations to detect which one is being handled. I'll get to that
later.

> If not, IMO this driver should get split up in two separate drivers, one
> serving SONY_PIC_HID and one serving SONY_NC_HID.

Oh no, we just merged them :)
Anyway, please feel free to add
Acked-by: Mattia Dongili <malattia@linux.it>
to this patch.

> > Also, I guess that when this patch set is applied we also should declare
> > sonypi obsolete as sony-laptop will grab the same device that sonypi
> > wants (the SPIC one). sony-laptop has options to avoid doing that would
> > make things clear to users.
> > I still haven't received reports of mafunctioning vaios using the new
> > sony-laptop instead of sonypi but 2.6.22 isn't final yet.
> 
> Sounds sane.
> Another problem that could come up in future is that new laptops could
> make use of the ACPI video spec (Appendix B) and of these vendor
> specific devices (I already saw this on an ASUS).
> While autoloading should still be ok (both are tried, maybe even both
> are needed), we need to find out which one need to be used in which
> condition.

AFAIK as far as vaios are concerned the spic device (ioport) is mostly
disappearing from newer models and most of the platform specific
operations are gathered through the methods of the acpi only SNC.
I'm also trying to get as many reports as possible[1] from vaio users to
build dmi {black,white}list for functionalities.
So I guess we are going the right direction.

[1]: with the help of TJ who has setup this nice page:
http://tjworld.net/sony-laptop/

Cheers
-- 
mattia
:wq!
