Return-Path: <linux-kernel-owner+w=401wt.eu-S933677AbXBYI4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677AbXBYI4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 03:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933680AbXBYI4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 03:56:51 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56607 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933677AbXBYI4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 03:56:50 -0500
Date: Sun, 25 Feb 2007 00:53:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: pavel@ucw.cz, greg@kroah.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, jmforbes@linuxtx.org, zwane@arm.linux.org.uk,
       tytso@mit.edu, rdunlap@xenotime.net, davej@redhat.com,
       chuckw@quantumlinux.com, reviews@ml.cw.f00f.org, mkrufky@linuxtv.org,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 01/18] bcm43xx: Fix for oops on resume
Message-Id: <20070225005330.50ec3280.akpm@linux-foundation.org>
In-Reply-To: <45E0F4D1.9080900@lwfinger.net>
References: <20070221014413.282048309@mini.kroah.org>
	<20070221014939.GB3684@kroah.com>
	<20070223052526.GA1889@elf.ucw.cz>
	<45E0F4D1.9080900@lwfinger.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 24 Feb 2007 20:30:41 -0600 Larry Finger <larry.finger@lwfinger.net> wrote:
> Pavel Machek wrote:
> > Hi!
> > 
> >> -stable review patch.  If anyone has any objections, please let us know.
> >>
> >> ------------------
> >> From: Larry Finger <Larry.Finger@lwfinger.net>
> >>
> >> There is a kernel oops on bcm43xx when resuming due to an overly tight timeout loop.
> >>
> >> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> >> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> >>
> >> ---
> >>  drivers/net/wireless/bcm43xx/bcm43xx.h |    2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> --- linux-2.6.18.7.orig/drivers/net/wireless/bcm43xx/bcm43xx.h
> >> +++ linux-2.6.18.7/drivers/net/wireless/bcm43xx/bcm43xx.h
> >> @@ -21,7 +21,7 @@
> >>  #define PFX				KBUILD_MODNAME ": "
> >>  
> >>  #define BCM43xx_SWITCH_CORE_MAX_RETRIES	50
> >> -#define BCM43xx_IRQWAIT_MAX_RETRIES	50
> >> +#define BCM43xx_IRQWAIT_MAX_RETRIES	100
> >>  
> >>  #define BCM43xx_IO_SIZE			8192
> > 
> > I'm sorry, but this does not look like fixing an oops. It may make it
> > go away for you, or make it less probable, but it certainly can't fix
> > it.
> 
> Upon resume, it was taking 65 times through the loop, which caused an oops. We think it is due to a
> slow-clock setting at that point, but it certainly does get rid of the oops. This change has also
> eliminated the odd oops seen by a few users.
> 

Pavel's point is that the driver shouldn't oops the kernel if
BCM43xx_IRQWAIT_MAX_RETRIES is exceeded.

Presumably, the driver will oops if bcm43xx_chip_init() fails for other
reasons?
