Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbXHZTRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbXHZTRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 15:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbXHZTRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 15:17:20 -0400
Received: from 15.61.79.83.cust.bluewin.ch ([83.79.61.15]:39132 "EHLO
	spock.one.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751450AbXHZTRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 15:17:20 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Aug 2007 15:17:19 EDT
Date: Sun, 26 Aug 2007 21:09:13 +0200
From: Michal Januszewski <spock@gentoo.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ondrej Zajicek <santiago@crfreenet.org>
Subject: Re: [Linux-fbdev-devel] [PATCH] fbdev: find mode with highest
	refresh rate in fb_find_mode()
Message-ID: <20070826190913.GA24286@spock.one.pl>
Reply-To: spock@gentoo.org
References: <20070718084102.GA22694@spock.one.pl> <20070718143803.GA5787@localhost.localdomain> <1184771895.4523.33.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1184771895.4523.33.camel@daplas>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 11:18:15PM +0800, Antonino A. Daplas wrote:

> > > Currently if the refresh rate is not specified fb_find_mode() returns
> > > the first known video mode with the requested resoluion, which provides
> > > no guarantees wrt the refresh rate.  Change this so that the mode with
> > > the highest refresh rate is returned instead.
> > 
> > What refresh rate it sets when used on card or monitor without DDC?
>
> Yes, I noted this also while reviewing patches.  fb_find_mode() is used
> predominantly with the 'generic' modedb which contains modes that are
> not specific to the card or monitor.  And fb_try_mode() is not a
> guarantee that the returned refresh rate will be safe (we have a lot of
> drivers that do not check the timings against the display capabilities).
> 
> It would be best that fb_find_mode() return the safest refresh rate
> (60Hz) instead of the highest.

How about modifying it so that it looks for a mode with the highest
refresh rate if either a non-generic modedb is used or
info.monspecs.{vfmin,vfmax,hfmin,hfmax,dclkmax} are all non-zero,
and for a mode with refresh rate closest to 60 Hz otherwise?

I'm sorry for the delayed reply.

Best regards.
-- 
Michal Januszewski                              JID: spock@im.gentoo.org
Gentoo Linux Developer                    http://people.gentoo.org/spock

