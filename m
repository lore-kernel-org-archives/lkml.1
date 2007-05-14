Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbXENUeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbXENUeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757255AbXENUeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:34:03 -0400
Received: from tim.rpsys.net ([194.106.48.114]:34760 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721AbXENUeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:34:00 -0400
Subject: Re: [PATCH 1/2] leds:arch/sh/boards/landisk LEDs supports
From: Richard Purdie <rpurdie@rpsys.net>
To: cbou@mail.ru
Cc: kogiidena@eggplant.ddo.jp, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org
In-Reply-To: <20070514201256.GB26554@zarina>
References: <1743.192.168.1.10.1178627210.squirrel@eggplant.ddo.jp>
	 <1178628889.6061.33.camel@localhost.localdomain>
	 <2490.192.168.1.10.1178720780.squirrel@eggplant.ddo.jp>
	 <1178723594.6291.21.camel@localhost.localdomain>
	 <20070509160328.GA13640@zarina>
	 <1179098182.5883.31.camel@localhost.localdomain>
	 <20070514201256.GB26554@zarina>
Content-Type: text/plain
Date: Mon, 14 May 2007 21:33:36 +0100
Message-Id: <1179174816.5877.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-15 at 00:12 +0400, Anton Vorontsov wrote:
> This change needed for two purposes:
> 
> 1. When somebody sets trigger, and that trigger would setup
>    brightness in its activate() function, and led driver would check
>    if that trigger supported (used by hwtimer trigger and drivers
>    supporting hw blinking LEDs, not in mainline yet).

Why does led_cdev->trigger need to be set to do this? Any well written
LED drivers shouldn't need to look at it as the LED drivers shouldn't
have or need any knowledge about specific triggers. If they need this,
you hw blinking abstraction isn't generic.

I had reservations about the hw blinking support last time we discussed
it but I can't remember the specifics of that discussion now without
looking it up. I'm going to hold this patch until we're about the merge
something that needs it, if it really needs it.

> 2. If trigger would access itself through led_cdev in its activate()
>    function.

I can't see why you'd need to do this...

> Pros of that patch:
> 
> 1. Just sane to do;
> 2. Trivial;
> 3. Can't break anything;
> 4. No new code, just one line movement.
> 
> Cons of applying that patch:
> 
> 1. No mainline kernel user, but offshores.

2. Encourages bad code ;-). 

-- 
Richard


