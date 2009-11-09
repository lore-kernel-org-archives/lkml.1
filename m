Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZKIXiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZKIXiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZKIXiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:38:23 -0500
Received: from mga10.intel.com ([192.55.52.92]:59556 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750928AbZKIXiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:38:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,711,1249282800"; 
   d="scan'208";a="512209748"
Subject: Re: [patch] added brightness feature to lcd class.
From: Richard Purdie <rpurdie@linux.intel.com>
To: InKi Dae <daeinki@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kyungmin Park <kmpark@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com>
References: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 23:35:05 +0000
Message-Id: <1257809705.29038.82.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 17:50 +0900, InKi Dae wrote:
> This patch adds brightness feature to lcd class.
> (kernel/driver/video/backlight/lcd.c)
> 
> In the past, most of the lcd panels for embedded system was TFT-LCD
> Panel needing backlight device.
> But now AMOLED LCD Panel appeared so we should consider brightness
> control for AMOLED Panel.
> 
> For the time being, I used backlight fake driver for brightness
> control of AMOLED LCD Panel.
> But this way is not good, so I propose to add brightness feature to lcd class.
> 
> For this, I attached patch file and if my proposal is approved
> Then I will send s6e63m0 and tl2796 AMOLED lcd panel driver based on
> lcd class modified soon.

Pavel has a good point but let me try and explain it differently.

The point of the backlight class is to expose a backlight brightness
control to userspace in a consistent well defined way. Anyone wishing to
write a piece of software to control the brightness of a backlight then
only needs to support *one* interface.

It is entirely accepted and normal that multiple "class" devices may
appear in userspace for one piece of physical hardware.

Your patch duplicates a userspace API and means any backlight
application would have to look for *two* different interfaces. This is
unacceptable.

Why can't your driver just register a backlight interface and an LCD
interface? I'd imagine your backlight and LCD can be powered on/off
separately too.

Please also cc: the backlight/lcd maintainer (me) on backlight/lcd
patches in future.

Andrew: Can you drop that patch from -mm please as I'm not convinced we
need two backlight brightness interfaces around...

Cheers,

Richard



