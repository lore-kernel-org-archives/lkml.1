Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbXENPVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbXENPVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 11:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbXENPUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 11:20:55 -0400
Received: from smtp-101-monday.nerim.net ([62.4.16.101]:4613 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754791AbXENPUy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 11:20:54 -0400
Date: Mon, 14 May 2007 17:21:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Antonino Ingargiola" <tritemio@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
Message-ID: <20070514172138.1c870793@hyperion.delvare>
In-Reply-To: <5486cca80705140628w5ff43ebdqf6a5413203226d5@mail.gmail.com>
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>
	<5486cca80705131010h2011487dnc948a3c57ce6decc@mail.gmail.com>
	<alpine.LFD.0.98.0705131046400.6739@woody.linux-foundation.org>
	<5486cca80705131150u313eeb43i30bf040e160ac419@mail.gmail.com>
	<20070514081022.7fcee97f@hyperion.delvare>
	<5486cca80705140134r318296b8k37ad6f4562b4b535@mail.gmail.com>
	<20070514141437.631fcfd1@hyperion.delvare>
	<5486cca80705140628w5ff43ebdqf6a5413203226d5@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 15:28:00 +0200, Antonino Ingargiola wrote:
> Hi Jean,
> 
> 2007/5/14, Jean Delvare <khali@linux-fr.org>:
> [cut]
> > This is a rather bad idea to build the abituguru and hdaps drivers into
> > your kernel if you don't have these devices. Especially abituguru, as
> > it does arbitrary port probing.
> 
> My bad. I have an abit motherboard and in doubt I selected the driver
> (and then leaved selected since all worked on previous kernels). I've
> disabled them and the problem persist.

Sure, I didn't expect it to solve the problem. But as a general advice,
hardware monitoring drivers are better selected as modules than
built-in.

> > > I'm not using any of the listed drivers.
> >
> > How strange, why are they loaded then?
> 
> My reply refers to your list of drivers that require a certain version
> of lm-sensors.

Ah, OK. Sorry, I got confused.

> > > However the lm-sensors package is version 2.10.1-3 and
> > > libsensors.so.3.1.1 is on my system too (package libsensors3).
> >
> > Can you please share the output of "sensors" under both kernels 2.6.21.1
> > and 2.6.22-rc1.
> 
> Sure. On 2.6.21.1:
> 
> via686a-isa-6000
> Adapter: ISA adapter
> CPU core:  +1.63 V  (min =  +0.06 V, max =  +3.10 V)
> +2.5V:     +2.45 V  (min =  +0.06 V, max =  +3.10 V)
> I/O:       +3.52 V  (min =  +3.12 V, max =  +3.45 V)   ALARM
> +5V:       +5.05 V  (min =  +4.73 V, max =  +5.20 V)
> +12V:     +12.30 V  (min = +11.35 V, max = +12.48 V)
> CPU Fan:     0 RPM  (min = 42187 RPM, div = 2)
> P/S Fan:  2657 RPM  (min = 42187 RPM, div = 2)          ALARM

Hint: increase the fan clock dividers to 4.

> SYS Temp:  +40.9°C  (high =  +146°C, hyst =   -71°C)
> CPU Temp:  +43.3°C  (high =  +146°C, hyst =   -71°C)
> SBr Temp:  +24.9°C  (high =   -63°C, hyst =   -71°C)   ALARM
> 
> while on 2.6.22-rc1:
> 
> via686a-i2c-9191-6000
>  ERROR: Can't get adapter or algorithm?!?

Ah, interesting. Could it be that the gnome applet quits because it
fails to get the adapter name? That wouldn't be very smart, but that's
possible.

This is a side effect of an i2c-core cleanup. This is already fixed in
lm_sensors 2.10.3 (libsensors.so.3.1.3). Care to give it a try and
confirm it fixes the problem? Note that it might be a bit tricky to get
the gnome applet to use your own libsensors rather than the system one.
You might need to set the LD_LIBRARY_PATH environment variable before
the applet starts, or something similar.

> CPU core:  +1.65 V  (min =  +0.06 V, max =  +3.10 V)
> +2.5V:     +2.45 V  (min =  +0.06 V, max =  +3.10 V)
> I/O:       +3.52 V  (min =  +3.12 V, max =  +3.45 V)   ALARM
> +5V:       +5.08 V  (min =  +4.73 V, max =  +5.20 V)
> +12V:     +12.24 V  (min = +11.35 V, max = +12.48 V)
> CPU Fan:     0 RPM  (min = 42187 RPM, div = 2)
> P/S Fan:     0 RPM  (min = 42187 RPM, div = 2)          ALARM
> SYS Temp:  +41.3°C  (high =  +146°C, hyst =   -71°C)
> CPU Temp:  +41.8°C  (high =  +146°C, hyst =   -71°C)
> SBr Temp:  +24.9°C  (high =   -63°C, hyst =   -71°C)   ALARM
> 
> In both kernels I have set:
> 
>      I2C Algorithms  --->
>       <M> I2C PCF 8584 interfaces
>       <M> I2C PCA 9564 interfaces

Irrelevant to your problem, but you most certainly need neither - else
they would have been selected automatically.

-- 
Jean Delvare
