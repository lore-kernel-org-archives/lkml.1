Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029Ab0AZWI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0AZWI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882Ab0AZWI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:08:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60849 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0AZWI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:08:27 -0500
Date: Tue, 26 Jan 2010 23:08:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>,
       airlied@linux.ie
Subject: Re: [PATCH] PM / i915: Skip kernel VT switch during suspend/resume
 if KMS is used
Message-ID: <20100126220816.GB19163@elf.ucw.cz>
References: <201001240055.59479.rjw@sisk.pl>
 <201001252254.37635.rjw@sisk.pl>
 <20100126141726.GA1437@ucw.cz>
 <201001261947.46015.rjw@sisk.pl>
 <20100126145842.GA11295@ucw.cz>
 <4B5F6299.6090903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5F6299.6090903@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-01-26 13:46:01, H. Peter Anvin wrote:
> On 01/26/2010 06:58 AM, Pavel Machek wrote:
> >>
> >> That would have to be done using suspend notifiers and should depend on what
> >> driver actually controls the screen at the moment.  And I guess the only case
> >> in which we actually _need_ to do the kernel VT switch is when the hardware
> >> is controlled by X and without KMS.
> > 
> > We need vt switch when display is controlled by userland app directly
> > accessing hw. It may or may not be X (svgalib anyone?,
> > gtk-on-framebuffer? qtopia?).
> > 
> > Ideally, userspace should explicitely tell us. KD_KERNEL_GRAPHICS
> > console mode?
> 
> It seems that the kernel would already know if it's in control of the
> mode switch, no? 

No, I do not think so. IIRC KD_GRAPHICS means "console is under
userland control"; X will use it even if it does not directly talk to
the hardware.

IOW kernel knows if userland *may* be in control of graphics hardware.

(And yes, not switching consoles when console is in KD_TEXT should be
easy and obvious optimalization).

Currently we have 

#define         KD_TEXT         0x00
#define         KD_GRAPHICS     0x01
#define         KD_TEXT0        0x02    /* obsolete */
#define         KD_TEXT1        0x03    /* obsolete */

I guess KD_KERNEL_GRAPHICS (or KD_INDIRECT_GRAPHICS or
KD_GRAPHICS_BUT_KERNEL_CAN_DO_CONSOLE_SWITCHING or something like
that) would be needed so that userland can indicate that no, cursor is
no longer welcome on the screen but no, it is not accessing hw
directly.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
