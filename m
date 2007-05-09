Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbXEIPGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbXEIPGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 11:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbXEIPGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 11:06:42 -0400
Received: from tim.rpsys.net ([194.106.48.114]:46810 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbXEIPGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 11:06:41 -0400
Subject: Re: [PATCH 2/2] leds:arch/sh/boards/landisk LEDs supports
From: Richard Purdie <rpurdie@rpsys.net>
To: kogiidena@eggplant.ddo.jp
Cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org
In-Reply-To: <2329.192.168.1.10.1178718316.squirrel@eggplant.ddo.jp>
References: <1743.192.168.1.10.1178627225.squirrel@eggplant.ddo.jp>
	 <1178628407.6061.24.camel@localhost.localdomain>
	 <1638.192.168.1.10.1178710979.squirrel@eggplant.ddo.jp>
	 <1178712861.6291.5.camel@localhost.localdomain>
	 <2329.192.168.1.10.1178718316.squirrel@eggplant.ddo.jp>
Content-Type: text/plain
Date: Wed, 09 May 2007 16:06:24 +0100
Message-Id: <1178723184.6291.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 22:45 +0900, kogiidena wrote:
> > On Wed, 2007-05-09 at 20:42 +0900, kogiidena wrote:
> >> >As far as I can tell, the existing timer trigger can do everything the
> >> >blink trigger can (and more besides).
> >> I want to blink LED in the initial state.
> >
> > Are you after to set that per LED or would some standard configurable
> > default for all LEDs work?
> I'm sorry.The meaning of the question cannot be understood.
> My LED is use in the following.
> I want to blink LED while booting it.
> When boot ends, LED is turned on.

Your device has more than one LED. Do you need to be able to configure
each LED individually or can they all have the same default settings?

> > The approach is probably a good idea but you'll have to split struct
> > timer_list timer from the data structure.

"struct timer_list timer" in "struct timer_trig_data" is unused when its
used for a default_trigger_data which is wasted space.

> > Also, if default_trigger wasn't the timer trigger you have a nice oops
> > waiting to happen.
> I'm sorry that it is not possible to understand enough.
> Please teach concretely.

You don't check default_trigger == "timer" before using
default_trigger_data.

Imagine we have:

struct led_classdev landisk_leds = {
       .name = "power",
       .default_trigger = "bitshift",
       .default_trigger_data =&default_bitshift_trig_data,
};

where:

struct bitshift_trig_data {
       unsigned long single_variable;
};

If you then:

echo "timer" > /sys/class/leds/power/trigger

your patch will use random data and possibly oops.

Regards,

Richard

