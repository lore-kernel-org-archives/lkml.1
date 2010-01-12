Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082Ab0ALR3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab0ALR3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456Ab0ALR3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:29:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:51257 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab0ALR3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:29:12 -0500
Date: Tue, 12 Jan 2010 17:28:33 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: David John <davidjon@xenontk.org>
cc: Johan Hovold <jhovold@gmail.com>, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] drm/kms: fix fbdev blanking regression
In-Reply-To: <4B458209.2030600@xenontk.org>
Message-ID: <alpine.LFD.2.00.1001121645570.9778@casper.infradead.org>
References: <1262797226-9593-1-git-send-email-jhovold@gmail.com> <1262797226-9593-2-git-send-email-jhovold@gmail.com> <alpine.LFD.2.00.1001061710510.5372@casper.infradead.org> <20100106180950.GD10442@localhost> <alpine.LFD.2.00.1001061814360.5372@casper.infradead.org>
 <20100106191234.GE10442@localhost> <4B458209.2030600@xenontk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On 01/07/2010 12:42 AM, Johan Hovold wrote:
> >> Yeap. The fix uncovered a bug in your driver. I haven't heard of problems 
> >> with the other drm drivers.
> >>  
> >>> The backlight is handled via the DRI driver I assume. At least
> >>> i9xx_crtc_dpms is called on powerdown.
> >>
> >> Can you post your dmesg and kernel config.
> 
> [snip]
> 
> Adding the Intel DRM people in CC as well. I have the same issue with my
> GM45.

Okay I looked at the code to figure out what is happening and why only 
this driver has problems. The problem is that the framebuffer layer 
expects the backlight to be a seperate device. The reason being is that
some embedded systems will use a gpio backlight. That way power management 
for a graphics card/backlight has 3 seperate states. Currently the intel 
DRM driver treats the backlight as being apart of the encoder. Jesse do 
you have objections to having the intel driver expose a backlight device.
The bonus of that is the user can also set the backlight levels.

 
