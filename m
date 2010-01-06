Return-Path: <linux-kernel-owner+w=401wt.eu-S932535Ab0AFSTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab0AFSTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932526Ab0AFSS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:18:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:33651 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470Ab0AFSS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:18:59 -0500
Date: Wed, 6 Jan 2010 18:18:41 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Johan Hovold <jhovold@gmail.com>
cc: Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/kms: fix fbdev blanking regression
In-Reply-To: <20100106180950.GD10442@localhost>
Message-ID: <alpine.LFD.2.00.1001061814360.5372@casper.infradead.org>
References: <1262797226-9593-1-git-send-email-jhovold@gmail.com> <1262797226-9593-2-git-send-email-jhovold@gmail.com> <alpine.LFD.2.00.1001061710510.5372@casper.infradead.org> <20100106180950.GD10442@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Commit 731b5a15a3b1474a41c2ca29b4c32b0f21bc852e (drm/kms: properly
> > > handle fbdev blanking) breaks console blanking on my laptop (GM45
> > > chipset). Instead of blanking the screen, it is dimmed and then the
> > > backlight starts "glowing" in the lower edges of the screen. The glowing
> > > then slowly spreads upwards. Does not look healthy at all...
> > > 
> > > This patch reverts to the old behaviour of going directly to
> > > DPMS_STANDBY.
> > 
> > The current fbdev blank is correct. Normal blanking doesn't power down 
> > the hsync or the vsync signals. If you look at fbdev drivers you will see 
> > this type of behavior. If you want a full power down then a FB_BLANK_POWERDOWN 
> > is needed. As for the blacklight that is a another problem not related to 
> > this issue. The fbdev layer sends a event to the backlight layer to tell 
> > it to power down. That powerdown happens for the backlight in all cases 
> > except FB_BLANK_UNBLANK. How is your backlight setup. Is the backlight 
> > handled via the DRI driver or acpi?
> > 
> 
> The change itself looks correct but it triggers something that seems to
> hurt my screen bad. :)

Yeap. The fix uncovered a bug in your driver. I haven't heard of problems 
with the other drm drivers.
 
> The backlight is handled via the DRI driver I assume. At least
> i9xx_crtc_dpms is called on powerdown.

Can you post your dmesg and kernel config.

