Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303AbZADOcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbZADOcg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 09:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZADOc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 09:32:27 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:57559 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbZADOc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 09:32:27 -0500
Date: Sun, 4 Jan 2009 15:34:59 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Mark Brown <broonie@sirena.org.uk>, Eric Miao <eric.miao@marvell.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Fix section mismatch in da903x
Message-ID: <20090104143459.GB2633@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1230814351-29527-1-git-send-email-broonie@sirena.org.uk> <f17812d70901011946p369bcd3bp8977405053cb6354@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f17812d70901011946p369bcd3bp8977405053cb6354@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 11:46:41AM +0800, Eric Miao wrote:
> Acked-by: Eric Miao <eric.miao@marvell.com>
> 
> Samuel, please help to merge.
Applied to the mfd tree, thanks guys.

Cheers,
Samuel.
 
> On Thu, Jan 1, 2009 at 8:52 PM, Mark Brown <broonie@sirena.org.uk> wrote:
> > The subdevice removal functions are marked __devexit but are referenced
> > from the error handling path when probing so are needed even when
> > __devexit functions are removed.
> >
> > Signed-off-by: Mark Brown <broonie@sirena.org.uk>
> > ---
> >  drivers/mfd/da903x.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
> > index 0b5bd85..248756f 100644
> > --- a/drivers/mfd/da903x.c
> > +++ b/drivers/mfd/da903x.c
> > @@ -435,13 +435,13 @@ static const struct i2c_device_id da903x_id_table[] = {
> >  };
> >  MODULE_DEVICE_TABLE(i2c, da903x_id_table);
> >
> > -static int __devexit __remove_subdev(struct device *dev, void *unused)
> > +static int __remove_subdev(struct device *dev, void *unused)
> >  {
> >        platform_device_unregister(to_platform_device(dev));
> >        return 0;
> >  }
> >
> > -static int __devexit da903x_remove_subdevs(struct da903x_chip *chip)
> > +static int da903x_remove_subdevs(struct da903x_chip *chip)
> >  {
> >        return device_for_each_child(chip->dev, NULL, __remove_subdev);
> >  }
> > --
> > 1.5.6.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> 
> -- 
> Cheers
> - eric

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
