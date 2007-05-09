Return-Path: <linux-kernel-owner+w=401wt.eu-S1760086AbXEIWS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbXEIWS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758805AbXEIWSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:18:48 -0400
Received: from p2020-adsah02tachib-acca.tokyo.ocn.ne.jp ([219.161.11.20]:60041
	"EHLO eggplant.ddo.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312AbXEIWSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:18:47 -0400
Message-ID: <1445.192.168.1.10.1178749125.squirrel@eggplant.ddo.jp>
In-Reply-To: <1178723184.6291.16.camel@localhost.localdomain>
References: <1743.192.168.1.10.1178627225.squirrel@eggplant.ddo.jp><1178628407.6061.24.camel@localhost.localdomain><1638.192.168.1.10.1178710979.squirrel@eggplant.ddo.jp><1178712861.6291.5.camel@localhost.localdomain><2329.192.168.1.10.1178718316.squirrel@eggplant.ddo.jp>
    <1178723184.6291.16.camel@localhost.localdomain>
Date: Thu, 10 May 2007 07:18:45 +0900 (JST)
Subject: Re: [PATCH 2/2] leds:arch/sh/boards/landisk LEDs supports
From: "kogiidena" <kogiidena@eggplant.ddo.jp>
To: "Richard Purdie" <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org
Reply-To: kogiidena@eggplant.ddo.jp
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Your device has more than one LED. Do you need to be able to configure
> each LED individually or can they all have the same default settings?
Yes. It need to be able to configure each LED individually as following.

this patch supports different two hardware.
LANDISK:
 LANDISK have two LED.
 power-led = blink.
 status-led = hard.

USL-5P:
 USK-5P have 7 LED and one BUZZER.
 power-led = blink.
 status-led = blink.
 led1 = none.
 led2 = none.
 led3 = none.
 led4 = none.
 led5 = none.
 buzzer = bitshift.

>> > The approach is probably a good idea but you'll have to split struct
>> > timer_list timer from the data structure.
>
> "struct timer_list timer" in "struct timer_trig_data" is unused when its
> used for a default_trigger_data which is wasted space.
>
>> > Also, if default_trigger wasn't the timer trigger you have a nice oops
>> > waiting to happen.
>> I'm sorry that it is not possible to understand enough.
>> Please teach concretely.
>
> You don't check default_trigger == "timer" before using
> default_trigger_data.
>
> Imagine we have:
>
> struct led_classdev landisk_leds = {
>        .name = "power",
>        .default_trigger = "bitshift",
>        .default_trigger_data =&default_bitshift_trig_data,
> };
>
> where:
>
> struct bitshift_trig_data {
>        unsigned long single_variable;
> };
>
> If you then:
>
> echo "timer" > /sys/class/leds/power/trigger
>
> your patch will use random data and possibly oops.

Thank you for explaining.
I understood the problem.
However, a complete solution is not hit on.

I think that it is the easiest solution to define the new trigger "Blink", and to use it.

kogiidena

