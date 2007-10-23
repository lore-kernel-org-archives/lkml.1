Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbXJWVun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbXJWVun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbXJWVue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:50:34 -0400
Received: from tim.rpsys.net ([194.106.48.114]:58535 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbXJWVud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:50:33 -0400
Subject: Re: [PATCH 2/3] leds-clevo-mail: hw accelerated LED blink extension
From: Richard Purdie <rpurdie@rpsys.net>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Rodrigo Pereira <rodripe@gmail.com>
In-Reply-To: <471B4BF2.2060205@freemail.hu>
References: <4718FCF3.4030401@freemail.hu>  <471B4BF2.2060205@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Date: Tue, 23 Oct 2007 22:49:45 +0100
Message-Id: <1193176185.5709.140.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-10-21 at 14:54 +0200, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Extends the leds subsystem with a blink_set() callback function which can
> be optionally implemented by a LED driver. If implemented, the driver can use
> the hardware acceleration for blinking a LED.
> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
> diff -uprN linux-2.6.23.orig/Documentation/leds-class.txt linux-2.6.23/Documentation/leds-class.txt
> --- linux-2.6.23.orig/Documentation/leds-class.txt	2007-10-09 22:31:38.000000000 +0200
> +++ linux-2.6.23/Documentation/leds-class.txt	2007-10-21 10:45:35.000000000 +0200
> @@ -47,6 +49,19 @@ overhead, I suggest these become part of
>  above leaves scope for further attributes should they be needed.
> 
> 
> +
> +Hardware accelerated blink of LEDs
> +==================================
> +
> +Some LEDs can be programmed to blink without any CPU interaction. To
> +support this feature, a LED driver can optionally implement the
> +blink_set() function (see <linux/leds.h>). If implemeted, the
> +ledtrig-timer tries to use it. The blink_set() function should return
> +0 if the blink setting is supported, or -EINVAL otherwise, which means
> +that the LED will be turned on and off from software by the leds
> +subsystem.

Hardware acceleration of the timer triggers is great to see and worst
case I'll happily apply this patch to the LED tree, thanks.

Before I do, I did wonder if we should enhance the meaning of the
set_blink function a bit. If set_blink is called with delay_on = 0,
delay_off = 0 it could mean "blink with some user friendly value,
hardware assisted". The use for this would be a more generic blink
trigger where you wouldn't need to know about magically hardware
assisted values for blinking, it would simply make an LED blink in a
hardware assisted way.

We also need to document that the brightness_set overrides any blinking
which may or may not be active (which is implied in your driver).

Cheers,

Richard


