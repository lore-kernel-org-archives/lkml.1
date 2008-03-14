Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbYCNW65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbYCNW65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 18:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYCNW6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 18:58:49 -0400
Received: from xenotime.net ([66.160.160.81]:36019 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751634AbYCNW6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 18:58:49 -0400
Date: Fri, 14 Mar 2008 15:58:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bastian Blank <bastian@waldi.eu.org>, rdunlap@xenotime.net,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       rui.zhang@intel.com
Subject: Re: [PATCH] THERMAL must not select HWMON
Message-Id: <20080314155845.2784acb9.rdunlap@xenotime.net>
In-Reply-To: <20080314134301.ed77baf7.akpm@linux-foundation.org>
References: <20080314175501.GA11107@wavehammer.waldi.eu.org>
	<20080314112112.c00cbcdd.rdunlap@xenotime.net>
	<20080314183758.GA15028@wavehammer.waldi.eu.org>
	<20080314134301.ed77baf7.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 13:43:01 -0700 Andrew Morton wrote:

> On Fri, 14 Mar 2008 19:37:58 +0100
> Bastian Blank <bastian@waldi.eu.org> wrote:
> 
> > On Fri, Mar 14, 2008 at 11:21:12AM -0700, Randy Dunlap wrote:
> > 
> > [ select forces HWMON to yes even if deps are never applicable ]
> > 
> > > Yes, that's a known & longstanding problem (that select does not
> > > follow/honor dependencies).
> > 
> > Okay.
> > 
> > So THERMAL can't select HWMON, instead it needs to do a proper depends.
> > 
> > Bastian
> > 
> > Signed-off-by: Bastian Blank <waldi@debian.org>
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > 
> > diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
> > index 3ab313e..394912c 100644
> > --- a/drivers/thermal/Kconfig
> > +++ b/drivers/thermal/Kconfig
> > @@ -4,7 +4,7 @@
> >  
> >  menuconfig THERMAL
> >  	bool "Generic Thermal sysfs driver"
> > -	select HWMON
> > +	depends on HWMON
> >  	default y
> >  	help
> >  	  Generic Thermal Sysfs driver offers a generic mechanism for
> 
> Sorry, but we have insufficient information here.
> 
> Presumably it fixes some build error, but the changelog should tell us (at
> least) what that error was, why it occurs and how the patch fixes it.

Bastian can report if he actually had a build error or not.

What he reported on the linux-kbuild mailing list is that
THERMAL selects HWMON.  However, HWMON depends on HAS_IOMEM, but
arch/s390 does not enable/support HAS_IOMEM.  Bang.

> Often (for bugfixes) I'll go off and find this stuff out from the mailing
> list and put together a proper description.  I also need to do this so I
> can work out whether the patch is needed in 2.6.25 or -stable.  But I can't
> even find any reference to the original problem in the lkml archives.


---
~Randy
