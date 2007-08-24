Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbXHXWQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbXHXWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 18:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbXHXWQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 18:16:42 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33174 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762749AbXHXWQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 18:16:29 -0400
Subject: Re: DM_MULTIPATH_RDAC: "scsi_normalize_sense" undefined
From: Chandra Seetharaman <sekharan@us.ibm.com>
Reply-To: sekharan@us.ibm.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Martin Michlmayr <tbm@cyrius.com>, Mike Christie <michaelc@cs.wisc.edu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070824150021.a7fdc9f6.randy.dunlap@oracle.com>
References: <20070824160834.GA7029@deprecation.cyrius.com>
	 <1187991182.17399.336.camel@linuxchandra>
	 <20070824150021.a7fdc9f6.randy.dunlap@oracle.com>
Content-Type: text/plain
Organization: IBM
Date: Fri, 24 Aug 2007 15:16:27 -0700
Message-Id: <1187993787.17399.343.camel@linuxchandra>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-24 at 15:00 -0700, Randy Dunlap wrote:
> On Fri, 24 Aug 2007 14:33:02 -0700 Chandra Seetharaman wrote:
> 
> > It does, but "rdac" _is_ for a SCSI device.
> 
> It does __what__ ?  depend on SCSI?

Yes, as you understood it correctly :)

> I don't see that in drivers/md/Kconfig.
> Sounds like Martin is correct, SCSI needs to be added, like below.

I do agree that the following patch would be needed.

Since the rdac hardware handler is for a scsi device, including it
without SCSI would not achieve anything (as his device won't be visible
in the first place). Hence my question.

For completeness, I agree that we need the fix pointed below.
> 
> 
> > What device are you using it with ?
> > 
> > On Fri, 2007-08-24 at 18:08 +0200, Martin Michlmayr wrote:
> > > I just got:
> > > 
> > >   Building modules, stage 2.
> > >   MODPOST 414 modules
> > > ERROR: "scsi_normalize_sense" [drivers/md/dm-rdac.ko] undefined!
> > > make[1]: *** [__modpost] Error 1
> > > 
> > > Presumably DM_MULTIPATH_RDAC needs to depend on SCSI (not enabled
> > > here) since it uses scsi_normalize_sense.
> 
> ---
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> DM_MULTIPATH_RDAC uses SCSI API(s) and is for a SCSI device,
> so add SCSI to its depends on to prevent build errors.
> 
> Not tested.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/md/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.23-rc3-git6.orig/drivers/md/Kconfig
> +++ linux-2.6.23-rc3-git6/drivers/md/Kconfig
> @@ -263,7 +263,7 @@ config DM_MULTIPATH_EMC
> 
>  config DM_MULTIPATH_RDAC
>  	tristate "LSI/Engenio RDAC multipath support (EXPERIMENTAL)"
> -	depends on DM_MULTIPATH && BLK_DEV_DM && EXPERIMENTAL
> +	depends on DM_MULTIPATH && BLK_DEV_DM && SCSI && EXPERIMENTAL
>  	---help---
>  	  Multipath support for LSI/Engenio RDAC.
> 
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------


