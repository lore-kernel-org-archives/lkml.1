Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZGKUql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZGKUql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 16:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbZGKUqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 16:46:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34828 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbZGKUqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 16:46:33 -0400
Date: Sat, 11 Jul 2009 22:46:31 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register:  warn if probe is in
	.init.text
Message-ID: <20090711204631.GA12446@pengutronix.de>
References: <20090616182310.GC13048@pengutronix.de> <1245418939-20758-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090619141128.GA11506@suse.de> <20090619144354.GA20985@pengutronix.de> <20090629075535.GA20155@pengutronix.de> <20090711033459.GC1344@suse.de> <20090711100014.GA9540@pengutronix.de> <20090711185920.GB25363@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090711185920.GB25363@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Sat, Jul 11, 2009 at 11:59:20AM -0700, Greg KH wrote:
> On Sat, Jul 11, 2009 at 12:00:14PM +0200, Uwe Kleine-König wrote:
> > Hi Greg,
> > 
> > > > Are you conviced and took the patch or did you give up to convince me?
> > > 
> > > Heh, no, sorry, it got burried in my queue.
> > > 
> > > > I still think the patch is correct and I'd like to have it applied.
> > > 
> > > Ok, let's test it out in the linux-next tree for a while to make sure it
> > > works properly.  Care to send me an updated version?
> > I updated to latest Linus' master.  It applies to linux-next from
> > Fri Jul 10 14:44:30 2009 +1000 as is.
> > 
> > Back some time I sent a series that fixes many of these bugs.  I will
> > update it later today and resend.
> > 
> > Best regards and thanks,
> > Uwe
> > 
> > ---->8----
> > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Subject: [PATCH] platform_driver_register:  warn if probe is in .init.text
> > 
> > with HOTPLUG=y it's wrong to register a platform_driver whose probe
> > function lives in .init.text because the probe function can be called
> > (e.g. via sysfs or by registering a device late) after the init sections
> > are already discarded.  This results in an oops.
> > 
> > So warn if such a driver is registered.
> > 
> > Without HOTPLUG the probe function can (and should) be discarded if the
> > driver is registered while the init sections are still available.
> > In this case warn if the probe function isn't discarded later.  (As
> > described in the comments there is a small chance for a wrong warning.
> > But as HOTPLUG=n is unusual today and the situation is strage enough to
> > be cleaned up anyhow, I think this is OK.)
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> This code kills the build in very bad ways :(
it's just a ; that didn't made it into the new version.  Don't know why.

If you squash the patch below into the patch I sent it should work
again.

Sorry
Uwe

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 298e9bc..2d48087 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -203,7 +203,7 @@ extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
 
 extern int core_kernel_text(unsigned long addr);
-extern int core_kernel_init_text(unsigned long addr)
+extern int core_kernel_init_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
 extern int kernel_init_text_address(unsigned long addr);

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
