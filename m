Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYEVPIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYEVPIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 11:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYEVPII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 11:08:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45257 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751536AbYEVPIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 11:08:07 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 May 2008 11:08:07 EDT
Date: Thu, 22 May 2008 16:01:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] wm97xx-core: Report a phys for WM97xx touchscreens
Message-ID: <20080522150119.GA25172@opensource.wolfsonmicro.com>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <1211456106-10882-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20080522093759.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522093759.ZZRA012@mailhub.coreip.homeip.net>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 09:41:48AM -0400, Dmitry Torokhov wrote:
> On Thu, May 22, 2008 at 12:35:06PM +0100, Mark Brown wrote:

> > phys is displayed in various diagnostic output so ensure that it is set
> > to something sensible.

> Phys is used to describe the physical connection of a device that is
> ideally not changing between reboots so having it set up based on
> device's bus_id is not a best option I think.

It didn't seem terribly wonderful to me either but I saw that some other
drivers were doing the same thing so I assumed it was idiomatic.  A
quick survey of devices on my laptop suggets that it's getting filled in
with USB bus IDs for some devices.

For a WM97xx device it should actually be OK almost all the time - AC97
bus identifiers are fixed in hardware, there would only be a problem if
additional AC97 buses are added which is relatively unlikely, especially
in the embedded applications where the WM97xx devices get used.
However, if it's supposed to be OK to leave this null then that would be
better.

> What tools besides evbug use phys? They probably should display both
> phys and sysfs paths (I will be changing evbug soon).

It was actually evbug that prompted this - it prints a rather alarming
'Connected device: "foo", NULL' when phys is left empty.
