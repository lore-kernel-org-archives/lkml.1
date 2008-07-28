Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbYG1IhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbYG1IhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 04:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYG1IhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 04:37:03 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:45895 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYG1IhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 04:37:00 -0400
Date: Mon, 28 Jul 2008 01:31:47 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Grant Likely <grant.likely@secretlab.ca>
cc: linux-kernel@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] leds: Support OpenFirmware led bindings
In-Reply-To: <20080727022116.GN12191@secretlab.ca>
Message-ID: <Pine.LNX.4.64.0807272159500.26456@t2.domain.actdsltmp>
References: <Pine.LNX.4.64.0807181339500.10116@t2.domain.actdsltmp>
 <1217019705-24244-2-git-send-email-tpiepho@freescale.com>
 <20080727022116.GN12191@secretlab.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008, Grant Likely wrote:
> On Fri, Jul 25, 2008 at 02:01:45PM -0700, Trent Piepho wrote:
>> Add bindings to support LEDs defined as of_platform devices in addition to
>> the existing bindings for platform devices.
>
>> +- gpios :  Should specify the LED GPIO.
>
> Question: it is possible/desirable for a single LED to be assigned
> multiple GPIO pins?  Say, for a tri-color LED?  (I'm fishing for
> opinions; I really don't know if it would be a good idea or not)

Good question.  The Linux LED layer has no concept of multi-color LEDs, so
it's more difficult that just adding support to the gpio led driver.  I have
a device with a tri-color red/green/orange LED and this posed some
difficulty.  It's defined as independent red and greed LEDs, which is mostly
fine, except I wanted it to flash orange.  I can make both the red LED and
green LED flash, but there is nothing to insure their flashing remains in
sync.

Other OF bindings allow multiple GPIOs to be listed in a gpios property, so
that's not a problem if someone wants to do that.  There would need to be a
way to define what the gpios mean.  I don't think it's worthwhile to come up
with a binding for that until there is a real user.

>> +- function :  (optional) This parameter, if present, is a string
>> +  defining the function of the LED.  It can be used to put the LED
>> +  under software control, e.g. Linux LED triggers like "heartbeat",
>> +  "ide-disk", and "timer".  Or it could be used to attach a hardware
>> +  signal to the LED, e.g. a SoC that can configured to put a SATA
>> +  activity signal on a GPIO line.
>
> This makes me nervous.  It exposes Linux internal implementation details
> into the device tree data.  If you want to have a property that
> describes the LED usage, then the possible values and meanings should be
> documented here.

Should it be a linux specific property then?  I could list all the current
linux triggers, but enumerating every possible function someone might want
to assign to an LED seems hopeless.

>> +		led.default_trigger =
>> +			of_get_property(child, "linux,default-trigger", NULL);
>
> This isn't in the documented binding.  I assume that you mean 'function'
> here?

Looks like I emailed the wrong patch file.  That should be changed to
"function" and there are a few cosmetic changes that are missing.
