Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbYELMre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbYELMre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 08:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbYELMrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 08:47:25 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:46245 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYELMrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 08:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LPKoADG+S32wL9HTpckMgCb2Q4S8WQJINnHDViBfhJZtG4jZkxh9sUbwuRkjS6SB/pN4l8n4721s7Tj/Ss2seoE/q3Be8BTmB8VjHKzvUeN48DclWvImaniWxRqPnQnV8t4d9cGOWdrU4HxIEarLKSwP0upJ1w5youFGJGEmO/c=
Message-ID: <8bd0f97a0805120547g5c46973fl538ad18d81a4aebc@mail.gmail.com>
Date: Mon, 12 May 2008 08:47:23 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>
Subject: Re: [PATCH 1/1] [INPUT/KEYPAD] gpio keypad: Replace current blackfin specific pfbutton driver with kernel generic gpio key driver
Cc: "pHilipp Zabel" <philipp.zabel@gmail.com>, dbrownell@users.sourceforge.net,
       dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <386072610805120511p5d1254cch26e2c8d5d0f755c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210587437-9751-1-git-send-email-cooloney@kernel.org>
	 <74d0deb30805120427x71b4588es9200f80252bab319@mail.gmail.com>
	 <8bd0f97a0805120442j3875b58bwab3959fdb3de9db2@mail.gmail.com>
	 <386072610805120511p5d1254cch26e2c8d5d0f755c7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 8:11 AM, Bryan Wu <cooloney@kernel.org> wrote:
> On Mon, May 12, 2008 at 7:42 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>> On Mon, May 12, 2008 at 7:27 AM, pHilipp Zabel
<philipp.zabel@gmail.com> wrote:
>>  > On Mon, May 12, 2008 at 12:17 PM, Bryan Wu <cooloney@kernel.org> wrote:
>>  >> From: Michael Hennerich <michael.hennerich@analog.com>
>>  >>
>>  >>  It's an actual deficiency in the hardware that we can't address,
>>  >>  so it needs to be worked around in software.
>>  >>
>>  >>  Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>>  >>  Signed-off-by: Bryan Wu <cooloney@kernel.org>
>>  >>  ---
>>  >>   drivers/input/keyboard/gpio_keys.c |   15 ++++++++++++++-
>>  >>   1 files changed, 14 insertions(+), 1 deletions(-)
>>  >>
>>  >>  diff --git a/drivers/input/keyboard/gpio_keys.c
>>  b/drivers/input/keyboard/gpio_keys.c
>>  >>  index bbd00c3..d856eb9 100644
>>  >>  --- a/drivers/input/keyboard/gpio_keys.c
>>  >>  +++ b/drivers/input/keyboard/gpio_keys.c
>>  >>  @@ -26,6 +26,18 @@
>>  >>
>>  >>   #include <asm/gpio.h>
>>  >>
>>  >>  +#if defined(CONFIG_BLACKFIN) && !defined(BF548_FAMILY)
>>  >>  +
>>  >>  +/*
>>  >>  + * On some Blackfin CPUs reading edge triggered
>>  >>  + * GPIOs doesn't return the current value
>>  >>  + */
>>  >
>>  > If this is a generic problem, shouldn't this be addressed inside
gpio_get_value?
>>
>>  it's an issue only when the GPIO is an interrupt source and the
>>  trigger condition is set to both rising and falling.  but i guess your
>>  point is that in gpio_get_value(), we can check to see if these
>>  conditions are met and if so, temporarily fiddle things there ?
>>
>>  Michael: that sounds reasonable, what do you think ?
>
> IMO, maybe it is feasible for fix this in generic GPIO layer, or will
> break other things?

where are you referring to ?  i think what's being proposed is to move
these checks to arch/blackfin/kernel/bfin_gpio.c ... any call to
gpio_get_value() under these circumstances will need the edge sense
toggle ...
-mike
