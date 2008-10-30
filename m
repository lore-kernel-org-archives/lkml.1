Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYJ3C01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYJ3C01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 22:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYJ3C0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 22:26:18 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:38165 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYJ3C0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 22:26:17 -0400
Date: Wed, 29 Oct 2008 19:21:24 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Anton Vorontsov <avorontsov@ru.mvista.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Richard Purdie <rpurdie@rpsys.net>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/4] of_gpio: Return GPIO flags from of_get_gpio()A
In-Reply-To: <20081028143933.GA18453@oksana.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.64.0810291857110.25957@t2.domain.actdsltmp>
References: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp>
 <1224889741-4167-1-git-send-email-tpiepho@freescale.com>
 <20081028143933.GA18453@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008, Anton Vorontsov wrote:
> On Fri, Oct 24, 2008 at 04:08:58PM -0700, Trent Piepho wrote:
>> + * @flags:	if non-NUll flags are returned here
>
> NULL, not NUll.

Thanks, fixed.

>> +			 const void *gpio_spec, unsigned int *flags)
>
> Why you made it unsigned int? In my original patch, I used
> named enum, which is self-documenting type.

I started writing this patch before you posted yours, and I didn't think of
the enum.  But you have a good point so I'll switch to an enum.

>> + * Flags as returned by OF GPIO chip's xlate function.
>> + * These do not need to be the same as the flags in the GPIO specifier in the
>> + * OF device tree, but it's convenient if they are.  The mm chip OF GPIO
>> + * driver works this way.
>
> This is not of_mm_gpio_chip specific.

of_mm_gpio_chip was just an example of a driver that uses the same flag format
for Linux and the OF binding.  I'll clarify the comment.

WRT changing the interface, Linux doesn't provide a stable kernel API. 
Functions that have been around far longer than of_get_gpio() and have far
more users have changed.  Yes, it is slightly annoying now.  But providing
backward compatibility for every single interface change will produce a
bloated and redundant API that will be around forever.

> Can you repost a fixed version with my Ack and Cc: Andrew Morton,
> Benjamin Herrenschmidt?
>
> I think this change should go into the 2.6.28, so that we can
> write new code on top of new API. Otherwise this change will cause
> issues in the next merge window.

If you can get your patch into Ben's -next tree before the high .28-RCs come
out, I can just rebase my patch to that tree and make the changes to any new
callers of of_get_gpio() that are there.
