Return-Path: <linux-kernel-owner+w=401wt.eu-S935549AbXFFUZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935549AbXFFUZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933954AbXFFUZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:25:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933715AbXFFUZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:25:24 -0400
Date: Wed, 6 Jun 2007 13:24:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070606132439.3f59f0cf.akpm@linux-foundation.org>
In-Reply-To: <200706062132.37430.m.kozlowski@tuxland.pl>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<200706062132.37430.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 21:32:36 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	This is from my P4 sony vaio laptop.
> 
> These warnings still there:
> 
> drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> sound/soc/sh/Kconfig:6:warning: 'select' used by config symbol 'SND_SOC_PCM_SH7760' refers to undefined symbol 'SH_DMABRG'

Yeah, people keep adding those and then never fixing them.  I've given up
and I just ignore them.

> A hwmon related build error:
> 
>   Building modules, stage 2.
>   MODPOST 187 modules
> ERROR: "input_register_polled_device" [drivers/hwmon/hdaps.ko] undefined!
> ERROR: "input_allocate_polled_device" [drivers/hwmon/hdaps.ko] undefined!
> ERROR: "input_free_polled_device" [drivers/hwmon/hdaps.ko] undefined!
> ERROR: "input_unregister_polled_device" [drivers/hwmon/hdaps.ko] undefined!
> ERROR: "input_register_polled_device" [drivers/hwmon/applesmc.ko] undefined!
> ERROR: "input_allocate_polled_device" [drivers/hwmon/applesmc.ko] undefined!
> ERROR: "input_free_polled_device" [drivers/hwmon/applesmc.ko] undefined!
> ERROR: "input_unregister_polled_device" [drivers/hwmon/applesmc.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

Yes, this is being argued on the lm-sensors list, of all places.  For now
you'll need to manually set CONFIG_INPUT_POLLDEV, I assume.


> And for some reason the whole Cryptographic API is under the main level of menu 
> (please find .config and menu.png attached).

err, yes.  git-cryptodev.patch did that.  Herbert is being immodest ;)
