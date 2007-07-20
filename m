Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbXGTSfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbXGTSfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758386AbXGTSfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:35:42 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39700 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752486AbXGTSfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:35:40 -0400
Date: Fri, 20 Jul 2007 20:35:03 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       linuxppc-dev@ozlabs.org
Subject: Re: [patch 1/3] m68k/mac: Make mac_hid_mouse_emulate_buttons()
	declaration visible
Message-ID: <20070720183503.GC3801@stusta.de>
References: <20070720164043.523003359@mail.of.borg> <20070720164323.625963918@mail.of.borg> <d120d5000707201047y2d22167co882a10176d79fce4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d120d5000707201047y2d22167co882a10176d79fce4@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 01:47:36PM -0400, Dmitry Torokhov wrote:
> Hi Geert,
>
> On 7/20/07, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> From: Geert Uytterhoeven <geert@linux-m68k.org>
>>
>> m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible
>>
>> drivers/char/keyboard.c: In function 'kbd_keycode':
>> drivers/char/keyboard.c:1142: error: implicit declaration of function 
>> 'mac_hid_mouse_emulate_buttons'
>>
>> The forward declaration of mac_hid_mouse_emulate_buttons() is not visible 
>> on
>> m68k because it's hidden in the middle of a big #ifdef block.
>>
>> Move it to <linux/hid.h>, correct the type of the second parameter, and
>> include <linux/hid.h> where needed.
>
> linux/hid.h contains definitions needed for drivers speaking HID
> protocol, I don't think we want to put quirks for legacy keyboard
> driver there. I'd just move the #ifdef within drivers/char/keyboard.c
> for now.
>...

If you only move it you will keep the bug of the wrong second parameter.

But if you move it to any header file gcc is able to figure out such 
errors itself instead of them being nasty runtime errors.

Such prototypes in C files are really bad since (like in this case) they 
prevent the finding of bugs. It doesn't matter which header file you put 
the prototype into (it can even be a new one), but it belongs into a 
header file.

> Dmitry

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

