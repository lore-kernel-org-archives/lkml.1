Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZBINCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZBINCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbZBINCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:02:31 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:28243 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbZBINCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:02:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QaH1mtIt8hRJ2hpziStdiMyukq41BJrCIwTfj5piiyzJptlXJUNmlcXep6OapnHpwU
         O6S9XK+N8bwVUxkA4rVmvPy4H+MbEOYML4tgdG4M0KLYsMxCAxcAXnuty+WFjhXXzDb4
         9ZPPt/PYtBGgJv21HBVRMGcyqHg1yu00IpLCA=
MIME-Version: 1.0
In-Reply-To: <200902070000.49089.david-b@pacbell.net>
References: <4e1455be0902062213o769a4d15ha0c892508839dbad@mail.gmail.com>
	 <200902070000.49089.david-b@pacbell.net>
Date: Mon, 9 Feb 2009 22:02:28 +0900
Message-ID: <4e1455be0902090502l554ca462m9c096e359a5b29c3@mail.gmail.com>
Subject: Re: [PATCH] twl4030-gpio: Fix getting the value of the TWL4030 GPIO 
	output pin
From: Joonyoung Shim <dofmind@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Tony Lindgren <tony@atomide.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/7 David Brownell <david-b@pacbell.net>:
> On Friday 06 February 2009, Joonyoung Shim wrote:
>> If TWL4030 GPIO pin is output, must read the value from REG_GPIODATAOUTx
>> register in twl4030_get_gpio_datainout().
>
> Why "must"?  The goal is to return the *actual* value of the pin,
> not the intended one.  When an external signal overwhelms the drive
> capability of that GPIO -- just a couple mA -- the correct value
> to return can't be the value written in the output register.

but, it doesn't return actual value of the pin if twl4030 GPIO pin is output.

For example, the GPIO13 pin of twl4030 is configured as an output
using gpio_direction_output() and assigns the GPIO's value to 1
using gpio_set_value_cansleep(), the result of "# cat /sys/kernel/debug/gpio"
reports to me as follows.

GPIOs 192-209, platform/twl4030_gpio, twl4030, can sleep:
 gpio-205 (keyled              ) out lo

but it should have reported "hi" instead of "lo".


>
> Plus, this patch won't even link ... you changed the name of the
> function at its definition, but not at its use points.

Sorry, i missed some code.

>
> NAK, unless you can show there's a real bug this addresses...
>
> - Dave
>
