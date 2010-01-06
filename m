Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068Ab0AFSJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0AFSJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:09:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045Ab0AFSJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:09:56 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37089 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab0AFSJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:09:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ndC+eZxj9ODc7im6F9d3QN4MarFfnEjk438imrAxKa3wqsFe9PsWmLpuCMfwKR4okM
         2XCZopfe1RT0k9IZ1B7DCpLWaIjqpyS+6AvMwM7gEAGK4/XH1lZXYS83s9UpYjrP1DpO
         FnDGCp/jcAJckMCEpAfXYOHGghAbwGwcwVZVU=
Date: Wed, 6 Jan 2010 19:09:50 +0100
From: Johan Hovold <jhovold@gmail.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Johan Hovold <jhovold@gmail.com>, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/kms: fix fbdev blanking regression
Message-ID: <20100106180950.GD10442@localhost>
References: <1262797226-9593-1-git-send-email-jhovold@gmail.com>
 <1262797226-9593-2-git-send-email-jhovold@gmail.com>
 <alpine.LFD.2.00.1001061710510.5372@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001061710510.5372@casper.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Commit 731b5a15a3b1474a41c2ca29b4c32b0f21bc852e (drm/kms: properly
> > handle fbdev blanking) breaks console blanking on my laptop (GM45
> > chipset). Instead of blanking the screen, it is dimmed and then the
> > backlight starts "glowing" in the lower edges of the screen. The glowing
> > then slowly spreads upwards. Does not look healthy at all...
> > 
> > This patch reverts to the old behaviour of going directly to
> > DPMS_STANDBY.
> 
> The current fbdev blank is correct. Normal blanking doesn't power down 
> the hsync or the vsync signals. If you look at fbdev drivers you will see 
> this type of behavior. If you want a full power down then a FB_BLANK_POWERDOWN 
> is needed. As for the blacklight that is a another problem not related to 
> this issue. The fbdev layer sends a event to the backlight layer to tell 
> it to power down. That powerdown happens for the backlight in all cases 
> except FB_BLANK_UNBLANK. How is your backlight setup. Is the backlight 
> handled via the DRI driver or acpi?
> 

The change itself looks correct but it triggers something that seems to
hurt my screen bad. :)

The backlight is handled via the DRI driver I assume. At least
i9xx_crtc_dpms is called on powerdown.

