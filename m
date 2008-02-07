Return-Path: <linux-kernel-owner+w=401wt.eu-S935665AbYBGVTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935665AbYBGVTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762854AbYBGVF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:05:29 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:53159 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934935AbYBGVFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:05:25 -0500
Date: Thu, 7 Feb 2008 22:05:30 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Marcin Juszkiewicz <openembedded@haerwu.biz>,
       Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080207210530.GA22357@uranus.ravnborg.org>
References: <20080207133805.13f092ff@dilbert.local> <20080207125824.GB7111@infradead.org> <20080207130117.GA18750@uranus.ravnborg.org> <200802071609.36960.openembedded@haerwu.biz> <20080207160557.GB28435@flint.arm.linux.org.uk> <20080207202329.GA21949@uranus.ravnborg.org> <20080207202940.GI28435@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207202940.GI28435@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 08:29:40PM +0000, Russell King - ARM Linux wrote:
> On Thu, Feb 07, 2008 at 09:23:29PM +0100, Sam Ravnborg wrote:
> > +# if PCMCIA is selected then we need IDE
> > +config ARM_PCMCIA
> > +	depends on PCMCIA
> 
> Shouldn't this be:
> 
> 	def_bool PCMCIA
yes - thanks.

> 
> ?
> 
> > +	select HAVE_IDE
> 
> Also, should this be something ARM specific - if you have PCMCIA you could
> have a CF card plugged in, so...  There's nothing ARM specific about that.

So we can replace the above with this:
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 519b4ff..8b22281 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -38,6 +38,7 @@ config PCMCIA_DEBUG
 config PCMCIA
        tristate "16-bit PCMCIA support"
        select CRC32
+       select HAVE_IDE
        default y
        ---help---
           This option enables support for 16-bit PCMCIA cards. Most older

Makes sense.

> 
> > +
> > +# select MTD except in a few corner configuration cases
> > +config ARM_MTD
> > +	depends on ALIGNMENT_TRAP || !CPU_CP15_MMU
> 
> Ditto.
Yes.

	Sam
