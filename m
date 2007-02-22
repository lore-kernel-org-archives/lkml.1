Return-Path: <linux-kernel-owner+w=401wt.eu-S965159AbXBVAfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965159AbXBVAfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965167AbXBVAe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:34:59 -0500
Received: from tim.rpsys.net ([194.106.48.114]:40645 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965159AbXBVAe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:34:58 -0500
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
From: Richard Purdie <rpurdie@rpsys.net>
To: Yaroslav Halchenko <lists@onerussian.com>,
       James Simmons <jsimmons@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <20070221055648.GM25659@washoe.onerussian.com>
References: <20070219044616.GC25659@washoe.onerussian.com>
	 <20070219000412.acad13de.akpm@linux-foundation.org>
	 <1171876788.6046.3.camel@localhost.localdomain>
	 <20070221055648.GM25659@washoe.onerussian.com>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 00:34:31 +0000
Message-Id: <1172104471.5790.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 00:56 -0500, Yaroslav Halchenko wrote:
> I didn't mention 2.6.20-mm1 and got to see -mm2 so it is the one which
> Iv'e tried, but, once again, I experienced the same issue with 19-mm?
> kernels.
> 
> I built 2.6.20-mm2 without backlight support
> $> grep BACKLIGH /boot/config-2.6.20-mm2 
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> # CONFIG_FB_BACKLIGHT is not set
> # CONFIG_FB_RIVA_BACKLIGHT is not set
> # CONFIG_FB_RADEON_BACKLIGHT is not set
> 
> that "eliminated" the problem. Also I can see the screen with pure
> 2.6.20 with backlight support (whatever it does since after
> loading lcd, backlight modules, my /sys/class/{lcd,backlight} are empty):
> 
> *$> grep BACKLIGH /boot/config-2.6.20 
> # CONFIG_FB_BACKLIGHT is not set
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_BACKLIGHT_CLASS_DEVICE=m
> CONFIG_BACKLIGHT_DEVICE=y
> 
> 
> > Also, do you normally see files under /sys/class/lcd?
> nope... after I load lcd module, no files under :-/ regardless either it
> is mm or not. But there are files under /sys/class/backlight/ for mm2
> compiled with backlight support (whenever the screen is dark as per my
> original email)

There should be no files appearing under /sys/class/lcd, so thats all
normal. There is another report with similar symptoms which also sounds
like enabling the following options are at fault:

# CONFIG_FB_RIVA_BACKLIGHT is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set

I suspect these options only work on certain hardware and aren't
generic. James, any idea what hardware these do/don't work with?

Worst case, we set them to depend on PMAC_BACKLIGHT again I guess...

Richard


