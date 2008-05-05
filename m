Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbYEEORW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbYEEORW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbYEEORO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:17:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:36501 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753140AbYEEORO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:17:14 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+bRBI+Mv2bKAom+46QLP6tsVwvp1on/Yzv/ZxZmj
	eGlagPlKz4mGGr
Date: Mon, 5 May 2008 16:17:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch] video: build fix for drivers/media/video/mt9v022.c
In-Reply-To: <20080503163058.GA15272@elte.hu>
Message-ID: <Pine.LNX.4.64.0805051604080.5648@axis700.grange>
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
> 
> The quick fix seems to be to include linux/gpio.h unconditionally. (this 
> seems like a small cleanup as well as it removes and #ifdef is more 
> robust than an inclusion of asm/gpio.h) Not tested too much yet, so 
> please have another look in any case.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Mauro, please pull this fix, extended with a similar fix for mt9m001 from 
another email from Ingo, along with a copy-paste error in a comment in 
mt9v022, from

http://linuxtv.org/hg/~gliakhovetski/v4l-dvb

Thanks
Guennadi
---
Guennadi Liakhovetski
