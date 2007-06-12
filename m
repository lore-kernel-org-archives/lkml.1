Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbXFLUPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbXFLUPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 16:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbXFLUPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 16:15:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:58877 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbXFLUPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 16:15:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UW2hAuAXFRjMk7dbyD1jR3MeUoFY/NhE93GMWvikCb/ZIiCYuAJ43GWTGF3Ywzwgj50GsdufnshantI7QvWQTsjVE1xFxJqd4LUHIvABmlrCl147JmRZtqXxqQb902WSrd38yHjntOMVbLt4rOSxVApJ9VpL4Zf2M2vRqskq5ic=
Message-ID: <929318d30706121315n3d2d20efp6fd3ff590cce894c@mail.gmail.com>
Date: Tue, 12 Jun 2007 22:15:37 +0200
From: "Giel de Nijs" <giel@caffeinetrip.com>
Reply-To: giel@caffeinetrip.com
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [PATCH] input: fix broken behaviour of Dell Latitude special keys
Cc: linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       "Vojtech Pavlik" <vojtech@suse.cz>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Matt Domsch" <matt_domsch@dell.com>,
       "Rezwanul Kabir" <rezwanul_kabir@dell.com>
In-Reply-To: <200706120127.25581.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <929318d30706101042q25418f9aif7c1a609fd792830@mail.gmail.com>
	 <200706120127.25581.dtor@insightbb.com>
X-Google-Sender-Auth: 835d210c44f432c2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On 6/12/07, Dmitry Torokhov <dtor@insightbb.com> wrote:

> Thank you for the patch. Is there any way I could see data coming from i8042
> when you press on these special keys? If you could do:
>
> echo 1 > /sys/module/i8042/parameters/debug
> tehn presses and released all these keys
> echo 0 > /sys/module/i8042/parameters/debug
>
> and send me dmesg I woudl appreciate that.

Here's the data from i8042 of, in order, Fn-F1, Fn-F3, Fn-F7, Fn-F8, Fn-Up,
Fn-Down, and Fn-Left:

drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [2277118]
drivers/input/serio/i8042.c: 0a <- i8042 (interrupt, 0, 1) [2277118]
drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [2277643]
drivers/input/serio/i8042.c: 07 <- i8042 (interrupt, 0, 1) [2277643]
drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [2277987]
drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [2277988]
drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [2278175]
drivers/input/serio/i8042.c: 0b <- i8042 (interrupt, 0, 1) [2278175]
drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [2279806]
drivers/input/serio/i8042.c: 06 <- i8042 (interrupt, 0, 1) [2279806]
drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [2279940]
drivers/input/serio/i8042.c: 05 <- i8042 (interrupt, 0, 1) [2279940]
drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [2280101]
drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [2280102]

As you can see, no release events :).

There's also Fn-End, Fn-PgUp, Fn-PgDown (all audio related) and the wireless
switch at the side, those do generate release events. Also, the Fn
combinations for num lock, scroll lock, sysrq and pause/break seem to act
normal. There's also Fn-Esc, but that's an ACPI key.

Hope this helps.

Greetings,
Giel
