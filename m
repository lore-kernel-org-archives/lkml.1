Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086Ab0AaIy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab0AaIy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 03:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607Ab0AaIy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 03:54:29 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52836 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab0AaIy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 03:54:28 -0500
Date: Sun, 31 Jan 2010 09:54:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, airlied@linux.ie,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH] PM / i915: Skip kernel VT switch during
 suspend/resume	if KMS is used
Message-ID: <20100131085419.GI2238@elf.ucw.cz>
References: <201001240055.59479.rjw@sisk.pl>
 <201001252254.37635.rjw@sisk.pl>
 <20100126141726.GA1437@ucw.cz>
 <201001261947.46015.rjw@sisk.pl>
 <20100126145842.GA11295@ucw.cz>
 <20100128000751.099630ed@strolchi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100128000751.099630ed@strolchi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-01-28 00:07:51, Stefan Seyfried wrote:
> Hi,
> 
> On Tue, 26 Jan 2010 15:58:43 +0100 Pavel Machek <pavel@ucw.cz> wrote:
> > We need vt switch when display is controlled by userland app directly
> > accessing hw. It may or may not be X (svgalib anyone?,
> > gtk-on-framebuffer? qtopia?).
> 
> anything-on-framebuffer should not be different from plain framebuffer
> console, or am I missing something?

It is. At least svgalib accesses hw directly. It probably can run even
on framebuffer.

> > Ideally, userspace should explicitely tell us. KD_KERNEL_GRAPHICS
> > console mode?
> > 
> > Plus the switch is needed for any graphics app using fbcon -- I do not
> > think we actually save the framebuffer over suspend. (This one should
> > probably be fixed).
> 
> Framebuffer should be easy to fix - it works pretty well already
> because apparently the fbcon code needs to "shadow buffer" all VT
> "windows" anyway - so maybe it's just the issue of doing an additional
> "redraw()" somewhere appropriate.

Well, for now the "shadow buffer" contains only text, not graphics
images. So you'd need to enlarge it a lot. Doable but more than one liner.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
