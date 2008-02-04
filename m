Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbYBDSJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbYBDSJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYBDSJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:09:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39973 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbYBDSJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:09:09 -0500
Date: Mon, 4 Feb 2008 10:06:17 -0800
From: Greg KH <greg@kroah.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Basic braille screen reader support
Message-ID: <20080204180617.GA22656@kroah.com>
References: <20080204031842.GE4439@implementation> <20080204171008.GA22050@kroah.com> <20080204172441.GP5205@implementation.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204172441.GP5205@implementation.uk.xensource.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 05:24:41PM +0000, Samuel Thibault wrote:
> Hello,
> 
> Greg KH, le Mon 04 Feb 2008 09:10:08 -0800, a ?crit :
> > On Mon, Feb 04, 2008 at 03:18:43AM +0000, Samuel Thibault wrote:
> > > This adds a minimalistic braille screen reader support.
> > > This is meant to be used by blind people e.g. on boot failures or when /
> > > cannot be mounted etc and thus the userland screen readers can not work.
> > 
> > Will this api work with the SpeakUp kernel drivers?  Are the hooks
> > sufficient for what those drivers are expecting?
> 
> SpeakUp and this are quite independant (though they will probably both
> end up in the drivers/a11y/ directory), at least just because the way
> they review the screen is very different.  Speech synthesis' matter is
> the time to say things, while braille's matter is the space to show
> things.
> 
> However, they share the same low-level primitives: the recently added
> keyboard and vc notifiers, screen_glyph(), inverse_translate(),
> kd_mksound, etc.

I guess I'm worried that the hooks that you add here will not be usable
by speakup, and we'll have to add more in places close to this, but not
quite the same.

I know speaking and "showing" are two different things, but they both
require the same data flow going into them in order to achieve their
goals, I just don't want to see this work being done without considering
both needs.

But, if you feel that both will work properly with these limited
exports, I have no objections.

thanks,

greg k-h
