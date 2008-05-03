Return-Path: <linux-kernel-owner+w=401wt.eu-S1762416AbYECRC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762416AbYECRC0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762886AbYECRB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:01:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:55560 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761093AbYECRBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:01:55 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+xrXBAFCGxlaBvaYda/rGOiYviV76N78Ishh7+UJ
	2CEirj/rIt94Vz
Date: Sat, 3 May 2008 19:02:08 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch] video: build fix for drivers/media/video/mt9v022.c
In-Reply-To: <20080503163058.GA15272@elte.hu>
Message-ID: <Pine.LNX.4.64.0805031853180.5182@axis700.grange>
References: <20080503163058.GA15272@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008, Ingo Molnar wrote:

> 
> x86.git testing found the following build bug on latest -git:
> 
>   CC [M]  drivers/media/video/mt9v022.o
>   drivers/media/video/mt9v022.c: In function 'bus_switch_request':
>   drivers/media/video/mt9v022.c:199: error: implicit declaration of function 'gpio_is_valid'
>   drivers/media/video/mt9v022.c:201: error: implicit declaration of function 'gpio_request'
>   drivers/media/video/mt9v022.c:207: error: implicit declaration of function 'gpio_direction_output'
>   drivers/media/video/mt9v022.c:211: error: implicit declaration of function 'gpio_free'
>   drivers/media/video/mt9v022.c: In function 'bus_switch_act':
>   drivers/media/video/mt9v022.c:237: error: implicit declaration of function 'gpio_set_value_cansleep'
>   make[2]: *** [drivers/media/video] Error 2
>   make[1]: *** [drivers/media] Error 2
>   make[1]: *** Waiting for unfinished jobs....
>   make: *** [drivers] Error 2
> 
> with this config:
> 
>    http://redhat.com/~mingo/misc/config-Sat_May__3_16_08_39_CEST_2008.bad
> 
> the bug was that the driver uses GPIO functionality but only includes 
> the GPIO interface definitions for the CONFIG_MT9M001_PCA9536_SWITCH 
> case, which was not set in this config.

Ok, once again a good catch and a wrong fix, sorry:-) The bug is that not 
CONFIG_MT9M001_PCA9536_SWITCH but CONFIG_MT9V022_PCA9536_SWITCH shall be 
checked for, of course. Copy-paste:-( I'll prepare a correct patch and 
submit it. As for the "cleanup" side - don't know. Would it be better to 
unconditionally include it? It won't hurt of course, looks better, but is 
unneeded when the GPIO is not used. And, although grep reports most 
drivers including asm/gpio.h, including linux/gpio.h seems indeed better.

Thanks
Guennadi
---
Guennadi Liakhovetski
