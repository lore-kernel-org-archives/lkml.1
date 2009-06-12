Return-Path: <linux-kernel-owner+w=401wt.eu-S1764548AbZFLOve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764548AbZFLOve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762690AbZFLOvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:51:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:44736 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760679AbZFLOvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:51:13 -0400
Date: Fri, 12 Jun 2009 16:51:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [BUG] [input] Sometimes mouse gets detected as PS2++ Logitech
 Mouse instead of ImPS/2 Logitech Wheel Mouse
In-Reply-To: <1244788506.6039.41.camel@mattotaupa.wohnung.familie-menzel.net>
Message-ID: <alpine.LRH.2.00.0906121649440.31685@twin.jikos.cz>
References: <1244788506.6039.41.camel@mattotaupa.wohnung.familie-menzel.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-input@ to CC ]

On Fri, 12 Jun 2009, Paul Menzel wrote:

> arbitrarily (I would say every two month) my Logitech Cordless MouseMan
> Wheel gets detected as (in dmesg)
> 
> PS2++ Logitech Mouse
> 
> instead of
> 
> ImPS/2 Logitech Wheel Mouse.

It would be nice if you could capture the dmesg output with i8042.debug 
command-line from the situation the mouse gets mis-detected. But I 
understand that with so low frequency of occurence, that would be a major 
pain.

[ left the rest of the message for linux-input@ ]

> 
> I notice this, if the scroll wheel does not work under X. Doing `sudo 
> rmmod psmouse` and `sudo modprobe psmouse` fixes the issue for me in 
> this (boot) session.

> 
> I have not found the reason for this and am not able to reproduce this.
> As written this issue pops up arbitrarily.
> 
> $ uname -a
> Linux x 2.6.29-1-amd64 #1 SMP Fri Apr 17 16:26:42 UTC 2009 x86_64 GNU/Linux
> 
> $ lsmod | grep mouse
> psmouse                41548  0
> 
> $ dmesg # excerpt
> [?]
> [    1.021991] input: Macintosh mouse button emulation as /devices/virtual/input/input0
> [    1.022270] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
> [    1.022734] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    1.022797] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    1.028167] mice: PS/2 mouse device common for all mice
> [?]
> [   25.007328] input: PC Speaker as /devices/platform/pcspkr/input/input5
> [   25.754932] input: PS2++ Logitech Mouse as /devices/platform/i8042/serio1/input/input6
> [?]
> # after doing `sudo rmmod psmouse` and `sudo modprobe psmouse`
> [ 1159.636233] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input7
> 
> $ diff -u /var/log/Xorg.0.log.old /var/log/Xorg.0.log | less # old is the ?good? version with scroll wheel working
> 
> (**) Macintosh mouse button emulation: (accel) filter chain progression: 2.00
>  (**) Macintosh mouse button emulation: (accel) filter stage 0: 20.00 ms
>  (**) Macintosh mouse button emulation: (accel) set acceleration profile 0
> -(II) config/hal: Adding input device ImPS/2 Logitech Wheel Mouse
> -(**) ImPS/2 Logitech Wheel Mouse: always reports core events
> -(**) ImPS/2 Logitech Wheel Mouse: Device: "/dev/input/event6"
> -(II) ImPS/2 Logitech Wheel Mouse: Found 3 mouse buttons
> -(II) ImPS/2 Logitech Wheel Mouse: Found x and y relative axes
> -(II) ImPS/2 Logitech Wheel Mouse: Found scroll wheel(s)
> -(II) ImPS/2 Logitech Wheel Mouse: Configuring as mouse
> -(**) ImPS/2 Logitech Wheel Mouse: YAxisMapping: buttons 4 and 5
> -(**) ImPS/2 Logitech Wheel Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
> -(II) XINPUT: Adding extended input device "ImPS/2 Logitech Wheel Mouse" (type: MOUSE)
> -(**) ImPS/2 Logitech Wheel Mouse: (accel) keeping acceleration scheme 1
> -(**) ImPS/2 Logitech Wheel Mouse: (accel) filter chain progression: 2.00
> -(**) ImPS/2 Logitech Wheel Mouse: (accel) filter stage 0: 20.00 ms
> -(**) ImPS/2 Logitech Wheel Mouse: (accel) set acceleration profile 0
> +(II) config/hal: Adding input device PS2++ Logitech Mouse
> +(**) PS2++ Logitech Mouse: always reports core events
> +(**) PS2++ Logitech Mouse: Device: "/dev/input/event6"
> +(II) PS2++ Logitech Mouse: Found 3 mouse buttons
> +(II) PS2++ Logitech Mouse: Found x and y relative axes
> +(II) PS2++ Logitech Mouse: Configuring as mouse
> +(**) PS2++ Logitech Mouse: YAxisMapping: buttons 4 and 5
> +(**) PS2++ Logitech Mouse: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
> +(II) XINPUT: Adding extended input device "PS2++ Logitech Mouse" (type: MOUSE)
> +(**) PS2++ Logitech Mouse: (accel) keeping acceleration scheme 1
> +(**) PS2++ Logitech Mouse: (accel) filter chain progression: 2.00
> +(**) PS2++ Logitech Mouse: (accel) filter stage 0: 20.00 ms
> +(**) PS2++ Logitech Mouse: (accel) set acceleration profile 0
>  (II) config/hal: Adding input device AT Translated Set 2 keyboard
>  (**) AT Translated Set 2 keyboard: always reports core events
>  (**) AT Translated Set 2 keyboard: Device: "/dev/input/event1"
> 
> 
> Do you know what could causing this? If I can provide more information,
> just tell me what.
> 
> 
> Thanks,
> 
> Paul
> 


-- 
Jiri Kosina
SUSE Labs

