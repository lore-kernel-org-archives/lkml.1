Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZGMLaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZGMLaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 07:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbZGMLaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 07:30:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48757 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZGMLaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 07:30:19 -0400
Date: Mon, 13 Jul 2009 12:30:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] mfd: Allow multiple MFD cells with the same name
Message-ID: <20090713113017.GB24783@sirena.org.uk>
References: <1246550798-9936-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246550798-9936-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: Everyone is entitled to my opinion.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 05:06:38PM +0100, Mark Brown wrote:
> Provide basic support for MFDs having multiple cells of a given
> type with different IDs by adding an id to the mfd_cell structure
> and then adding that to the id passed in to mfd_add_devices().
> 
> As it stands this approach requires that MFDs using this feature
> deal with ensuring that there aren't any ID collisions resulting
> from multiple MFDs of the same type being instantiated. This needs
> to happen with the existing code too, but with this approach there
> is a knock on effect on the IDs for non-duplicated devices.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Samuel, do you have any thoughts on this patch?  As I said...

> I'm not 100% convinced that this is the best way to do this but I can't
> think of anything better

...but it'd be really helpful to get some idea if this approach is going
to be viable for some code I'm currently working on.

> 
>  drivers/mfd/mfd-core.c   |    2 +-
>  include/linux/mfd/core.h |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index 54ddf37..ae15e49 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -25,7 +25,7 @@ static int mfd_add_device(struct device *parent, int id,
>  	int ret = -ENOMEM;
>  	int r;
>  
> -	pdev = platform_device_alloc(cell->name, id);
> +	pdev = platform_device_alloc(cell->name, id + cell->id);
>  	if (!pdev)
>  		goto fail_alloc;
>  
> diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
> index 49ef857..11d740b 100644
> --- a/include/linux/mfd/core.h
> +++ b/include/linux/mfd/core.h
> @@ -23,6 +23,7 @@
>   */
>  struct mfd_cell {
>  	const char		*name;
> +	int			id;
>  
>  	int			(*enable)(struct platform_device *dev);
>  	int			(*disable)(struct platform_device *dev);
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
"You grabbed my hand and we fell into it, like a daydream - or a fever."
