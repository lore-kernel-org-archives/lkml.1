Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZGXWdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZGXWdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 18:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbZGXWdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 18:33:52 -0400
Received: from mga05.intel.com ([192.55.52.89]:7962 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751834AbZGXWdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 18:33:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,266,1246863600"; 
   d="scan'208";a="710849354"
Date: Sat, 25 Jul 2009 00:35:55 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] mfd: Allow multiple MFD cells with the same name
Message-ID: <20090724223554.GA10055@sortiz.org>
References: <1246550798-9936-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20090713113017.GB24783@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713113017.GB24783@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jul 13, 2009 at 12:30:18PM +0100, Mark Brown wrote:
> On Thu, Jul 02, 2009 at 05:06:38PM +0100, Mark Brown wrote:
> > Provide basic support for MFDs having multiple cells of a given
> > type with different IDs by adding an id to the mfd_cell structure
> > and then adding that to the id passed in to mfd_add_devices().
> > 
> > As it stands this approach requires that MFDs using this feature
> > deal with ensuring that there aren't any ID collisions resulting
> > from multiple MFDs of the same type being instantiated. This needs
> > to happen with the existing code too, but with this approach there
> > is a knock on effect on the IDs for non-duplicated devices.
> > 
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Samuel, do you have any thoughts on this patch?  As I said...
I think it's safe to expect people that decide they need this feature will be
careful enough to make sure they dont get ID collisions.

 
> > I'm not 100% convinced that this is the best way to do this but I can't
> > think of anything better
> 
> ...but it'd be really helpful to get some idea if this approach is going
> to be viable for some code I'm currently working on.
I'm ok with this patch, but I'd like the new cell->id field to be more
documented. In particular we should mention that one should leave it to 0
unless trying to add several cells of the same type.
I'll push this patch once I'll be back from vacation, thanks.

Cheers,
Samuel.


> 
> > 
> >  drivers/mfd/mfd-core.c   |    2 +-
> >  include/linux/mfd/core.h |    1 +
> >  2 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> > index 54ddf37..ae15e49 100644
> > --- a/drivers/mfd/mfd-core.c
> > +++ b/drivers/mfd/mfd-core.c
> > @@ -25,7 +25,7 @@ static int mfd_add_device(struct device *parent, int id,
> >  	int ret = -ENOMEM;
> >  	int r;
> >  
> > -	pdev = platform_device_alloc(cell->name, id);
> > +	pdev = platform_device_alloc(cell->name, id + cell->id);
> >  	if (!pdev)
> >  		goto fail_alloc;
> >  
> > diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
> > index 49ef857..11d740b 100644
> > --- a/include/linux/mfd/core.h
> > +++ b/include/linux/mfd/core.h
> > @@ -23,6 +23,7 @@
> >   */
> >  struct mfd_cell {
> >  	const char		*name;
> > +	int			id;
> >  
> >  	int			(*enable)(struct platform_device *dev);
> >  	int			(*disable)(struct platform_device *dev);
> > -- 
> > 1.6.3.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
> -- 
> "You grabbed my hand and we fell into it, like a daydream - or a fever."

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
