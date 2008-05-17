Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbYEQTR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbYEQTR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 15:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbYEQTRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 15:17:03 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61347 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755308AbYEQTRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 15:17:00 -0400
Date: Sat, 17 May 2008 20:16:20 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
cc: a.zummo@towertech.it, hvr@gnu.org, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC: M41T80: Century Bit support
In-Reply-To: <20080518.000242.41199304.anemo@mba.ocn.ne.jp>
Message-ID: <Pine.LNX.4.55.0805171959030.10067@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805170057370.4049@cliff.in.clinika.pl>
 <20080518.000242.41199304.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008, Atsushi Nemoto wrote:

> This patch enforces that all (including future) users of this device
> must use same interpretation of CB bit.  I think this is too
> intrusive.

 I feared so, but on the other hand I did not want to introduce yet 
another kernel/module command line parameter -- there are too many of them 
already. :-(

> And I have one (out-of-tree, and only one in the world) board with
> this device and its firmware uses different interpretation.
> Fortunately I can change this firmware, so this is not a serious
> problem for me. ;)

 Hmm, how about pushing your bits upstream? ;-)

> How about doing like this?
> 
> 1. If CEB was 0, keep current behavior. (does not touch CB bit)
> 
> 2. If CEB was 1, detect polarity of CB bit on get_datetime, and set or
>    clear CB bit on set_datetime based on the polarity.

 That's what I did initially as it is as obvious as you can get.  But as I
noted, CFE, the firmware used with the SWARM, does not set CEB even though
it takes CB into account.  The approach is not useful therefore at least
for one major user of the device.

 Of course CFE is BSD-licensed and can be changed too, but based on my
experience with how serious bugs are handled, I would not count on getting
such a minor change integrated into the official sources.

> Please look at "c_polarity" variable in rtc-pcf8563.c driver.

 Hmm, not terribly useful as few of us if anybody live back in the 20th
century. ;-)  I think let's scrap the patch in this case and let our
grandchildren solve the problem -- a proposal has been published and can
be reused as needed.

  Maciej
