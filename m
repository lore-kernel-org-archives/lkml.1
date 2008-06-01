Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYFAXWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYFAXWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbYFAXW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:22:26 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:49064 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbYFAXWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:22:25 -0400
Subject: Re: [drm:radeon_cp_idle] *ERROR* radeon_cp_idle called without
	lock held
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sourceforge.net
In-Reply-To: <alpine.DEB.0.82.0806012310440.5760@skynet.skynet.ie>
References: <1212347789.2580.9.camel@odie.local>
	 <alpine.DEB.0.82.0806012218560.5760@skynet.skynet.ie>
	 <1212358046.6296.12.camel@odie.local>
	 <alpine.DEB.0.82.0806012310440.5760@skynet.skynet.ie>
Content-Type: text/plain; charset=utf-8
Date: Mon, 02 Jun 2008 01:22:40 +0200
Message-Id: <1212362560.9513.2.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

søn, 01 06 2008 kl. 23:11 +0100, skrev Dave Airlie:
> > 
> > Backtrace:
> > 0: X(xf86SigHandler+0x80) [0x80d29f0]
> > 1: [0xb7f54400]
> > 2: /usr/lib/xorg/modules/input//evdev_drv.so [0xb7aab90e]
> > 3: X [0x80d2b87]
> > 4: X [0x80b6065]
> > 5: [0xb7f54400]
> > 6: X(Dispatch+0x81) [0x808d5d1]
> > 7: X(main+0x485) [0x8074bb5]
> > 8: /lib/libc.so.6(__libc_start_main+0xdc) [0xb7c813ec]
> > 9: X(FontFileCompleteXLFD+0x229) [0x8073f21]
> > 
> > Fatal server error:
> > Caught signal 11.  Server aborting
> 
> Looks like X is dying in its input driver, which is causing the video 
> driver to do something without the lock, so its an X.org configuration or 
> build issues.. best ask on xorg@lists.freedesktop.org

You are right, this was simply freedesktop.org bug #13991 [1] which has
been solved since January [2], but not made it into a release of
xf86-input-evdev yet.

So I still want to do something about the throttling issue of the kernel
messages, but that's gonna wait as I'm off to bed now.

Thanks Dave.


﻿Simon Holm Thøgersen

[1] http://bugs.freedesktop.org/show_bug.cgi?id=13991
[2]
http://gitweb.freedesktop.org/?p=xorg/driver/xf86-input-evdev.git;a=commit;h=5adbc6b98ca1da9a426528ce0df64a992feff3bd


