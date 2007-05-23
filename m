Return-Path: <linux-kernel-owner+w=401wt.eu-S1760789AbXEWArl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760789AbXEWArl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756985AbXEWArd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:47:33 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:25520 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbXEWArd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:47:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NM4zTfDd4bPjML03WLwzmM6Tm0WwjnsM5IDLpQXkVZQbKRnKYYje8IaZ2mqUfBcCyF5BbDFugF2LaO5YWNtmyOmWMuSVj7sPJhqMH2EvmOourvCUCCGgO+pnloPsqIWppD5IZJOVFHk782afsnxPP7JzOzr47nXKfWNQQs9cLFw=
Subject: Re: [PATCH 2/2] make fbcon unregister when unloaded
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       James Simmons <jsimmons@pentafluge.infradead.org>
In-Reply-To: <200705221514.17041.jesse.barnes@intel.com>
References: <200705171423.46748.jesse.barnes@intel.com>
	 <200705221444.52675.jbarnes@virtuousgeek.org>
	 <20070522150504.b797213a.randy.dunlap@oracle.com>
	 <200705221514.17041.jesse.barnes@intel.com>
Content-Type: text/plain
Date: Wed, 23 May 2007 08:47:26 +0800
Message-Id: <1179881246.4638.13.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 15:14 -0700, Jesse Barnes wrote:
> On Tuesday, May 22, 2007 3:05 pm Randy Dunlap wrote:
> > On Tue, 22 May 2007 14:44:52 -0700 Jesse Barnes wrote:
> > > When unloaded, the fbcon driver should unregister itself from the
> > > VT subsystem using unbind_con_driver.  This patch makes it use the
> > > newly exported function to do just that.
> > >
> > > Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>
> > >
> > > diff -Napur -X /home/jbarnes/dontdiff --exclude=Makefile
> > > linux-2.6.22-rc2/drivers/video/console/fbcon.c
> > > linux-2.6.22-rc2-modesetting/drivers/video/console/fbcon.c ---
> > > linux-2.6.22-rc2/drivers/video/console/fbcon.c	2007-05-18
> > > 21:06:17.000000000 -0700 +++
> > > linux-2.6.22-rc2-modesetting/drivers/video/console/fbcon.c	2007-05-
> > >22 14:26:20.000000000 -0700 @@ -2937,6 +2937,21 @@ static int
> > > fbcon_mode_deleted(struct fb_ return found;
> > >  }
> > >
> > > +static int fbcon_fb_unbind(int idx)
> > > +{
> > > +	int i;
> > > +
> > > +        for (i = 0; i < MAX_NR_CONSOLES; i++) {
> > > +                /* Assure we do not unbind other drivers */
> > > +                if (idx == con2fb_map[i])
> > > +                        /* can be optimize to minimize multiple
> > > calls to +			   unbind_con_driver() */
> >
> > 			/*
> > 			 * can be optimized to minimize multiple calls
> > 			 * to unbind_con_driver()
> > 			 */
> >
> > > +                        unbind_con_driver(&fb_con, i, i, 0);
> > > +        }
> > > +
> > > +	return 0;
> > > +}
> >
> > Lots of whitespace mangling there (mostly spaces instead of tabs).
> 
> Oops, thanks for looking.  Somehow my emacs configuration broke and I 
> don't see this as readily as I used to.  If Antonio is ok with the 
> patch otherwise, I'll respin it with the cleanups.

This should be a lot safer than the previous patch. This is fine as long
as only a single driver is driving the console. For multiple drivers, it
will need the change that I promised weeks ago :-). (And I will work on
it soon).

Tony

