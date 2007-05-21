Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbXEUEQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbXEUEQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 00:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbXEUEQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 00:16:24 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:7315 "EHLO
	asav19.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbXEUEQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 00:16:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoXABi6UEZKhRO4W2dsb2JhbACBXIVniEUdDQURAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Renato Golin <rengolin@gmail.com>
Subject: Re: joydev.c and saitek cyborg evo force
Date: Mon, 21 May 2007 00:16:20 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
In-Reply-To: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705210016.20794.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 May 2007 09:54, Renato Golin wrote:
> Hi,
> 
> I'm a kernel newbie so please, pardon my French.
> 
> I have a Saitek Cyborg Evo Force, a very good joystick with force-
> feedback. Problem is, on Windows it works well (its drivers know its
> own idiosyncrasies) but on Linux it gets a bit fuzzy.
> 
> The behaviour is that, all axis are working fine, except up/down
> (elevator) and left/right (aileron) that gives me "random"
> signed/unsigned values.
> 
> A smaller problem is that it's reporting 8 axis but have 6 only and 13
> buttons but have only 12 and the 12th button is always pressed,
> messing fgjs setup utility.
> 
> Digging drivers/input/joydev.c I found out that if I remove the
> correction (setting
> JS_CORR_NONE) the values come correct, in a range from 0 to 4096.
> 
> Problem is, on joydev_connect, when defining the corrections for every
> axis, the joystick is reporting dev->absmax = 127 and dev->absmin =
> -127 for both axis 0 and 1, so the correction is based on a signed
> range when the joystick is actually sending an unsigned range.
> 
> Also, because the module was expecting up to 127 on value and is getting
> 4094, when the correction does a left shift it might be setting the
> signal bit (leftmost) and that could explain why I'm getting random
> signed/unsigned values.
> 
> The only way to know what is the real range is when you're actually
> pushing and pulling the stick so the change I'm willing to make is to
> recalibrate (ie. redefine the correction) whenever the raw value goes
> off limits. But that would only extend 127 to 4096 but won't change -127
> to 0.
> 
> Another alternative is to do a dynamic calibration whenever you move the
> stick from the beginning and not do it based on what the joystick is
> telling you to (ie. at connect time). But that might be a lot of useless
> work when the control gives you the correct range in the first place.
> 
> At last, hardcoding "if (saitek)" is quite ugly but can be done for the
> sake of performance.
> 

I think we need to make HID driver to report real range for Saitek.
Jiri, any ideas?

-- 
Dmitry
