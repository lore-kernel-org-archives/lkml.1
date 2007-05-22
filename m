Return-Path: <linux-kernel-owner+w=401wt.eu-S935306AbXEVWO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935306AbXEVWO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759977AbXEVWOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:14:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:7613 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759904AbXEVWOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:14:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,567,1170662400"; 
   d="scan'208";a="230991416"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2/2] make fbcon unregister when unloaded
Date: Tue, 22 May 2007 15:14:16 -0700
User-Agent: KMail/1.9.6
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>
References: <200705171423.46748.jesse.barnes@intel.com> <200705221444.52675.jbarnes@virtuousgeek.org> <20070522150504.b797213a.randy.dunlap@oracle.com>
In-Reply-To: <20070522150504.b797213a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221514.17041.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 22, 2007 3:05 pm Randy Dunlap wrote:
> On Tue, 22 May 2007 14:44:52 -0700 Jesse Barnes wrote:
> > When unloaded, the fbcon driver should unregister itself from the
> > VT subsystem using unbind_con_driver.  This patch makes it use the
> > newly exported function to do just that.
> >
> > Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
> >
> > diff -Napur -X /home/jbarnes/dontdiff --exclude=Makefile
> > linux-2.6.22-rc2/drivers/video/console/fbcon.c
> > linux-2.6.22-rc2-modesetting/drivers/video/console/fbcon.c ---
> > linux-2.6.22-rc2/drivers/video/console/fbcon.c	2007-05-18
> > 21:06:17.000000000 -0700 +++
> > linux-2.6.22-rc2-modesetting/drivers/video/console/fbcon.c	2007-05-
> >22 14:26:20.000000000 -0700 @@ -2937,6 +2937,21 @@ static int
> > fbcon_mode_deleted(struct fb_ return found;
> >  }
> >
> > +static int fbcon_fb_unbind(int idx)
> > +{
> > +	int i;
> > +
> > +        for (i = 0; i < MAX_NR_CONSOLES; i++) {
> > +                /* Assure we do not unbind other drivers */
> > +                if (idx == con2fb_map[i])
> > +                        /* can be optimize to minimize multiple
> > calls to +			   unbind_con_driver() */
>
> 			/*
> 			 * can be optimized to minimize multiple calls
> 			 * to unbind_con_driver()
> 			 */
>
> > +                        unbind_con_driver(&fb_con, i, i, 0);
> > +        }
> > +
> > +	return 0;
> > +}
>
> Lots of whitespace mangling there (mostly spaces instead of tabs).

Oops, thanks for looking.  Somehow my emacs configuration broke and I 
don't see this as readily as I used to.  If Antonio is ok with the 
patch otherwise, I'll respin it with the cleanups.

Thanks,
Jesse
