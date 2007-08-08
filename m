Return-Path: <linux-kernel-owner+w=401wt.eu-S964828AbXHHUau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbXHHUau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 16:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764376AbXHHUak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 16:30:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:53383 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965137AbXHHUai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 16:30:38 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18vSFYfu7Ev3P9aczrHQR0j7VgnoMbToekFMN0zGT
	hBMAVsQ3k+ltjG
Date: Wed, 8 Aug 2007 22:30:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Oncaphillis <oncaphillis@snafu.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: UART misbehaves under Linkstation/KuroBoxHG 
In-Reply-To: <46B9CE82.1050000@snafu.de>
Message-ID: <Pine.LNX.4.60.0708082219520.6767@poirot.grange>
References: <46B9CE82.1050000@snafu.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Oncaphillis wrote:

> Greetings,
> 
> I'm trying to compile a 2.6.2x kernel on a Linkstation/KuroBox HG/ppc
> following instructions given under
> http://www.kurobox.com/mwiki/index.php/Kurobox_support_in_stock_2.6_kernels

Wow, congratulations! Not too many endevour into this land, and even fewer 
succeed:-) You'd probably be better off asking this on linuxppc-dev, but 
anyway...

> and get weired settings and errors from the serial device (UART 16550A).
> 
> Under the 2.4.17 kernel provided by the Kurobox manufacturer it gets IRQS in
> the range of 137/138 under 2.6.22 for the linkstation it gets IRQS 17/18 and
> the serial device behaves fishy

That interrupt numbers are different as under 2.4 is correct, however, I 
get 16 and 17 for ttyS0 and ttyS1 on a kuroboxHG, are you sure you're 
getting 17 and 18?

> communication errors
> 
> "to much work in IRQ 16"

And here you get IRQ 16, which indeed should be ttyS0. And ttyS0 is 
connected to the power-management microcontroller (AVR). Wait, what 
userspace are you running? Have you swapped ttyS0 and ttyS1 everywhere? in 
/etc/inittab for example? Besides, if you are running any vendor provided 
(or community) tools to handle the AVR - they use ttyS1 by default, as it 
was under 2.4 ans under "traditional" 2.6, whereas the 2.6 mainline kernel 
for kurobox/linkstation uses the traditional for these CPUs port 
numbering. I think this is your problem. Some user-space programme(s) are 
accessing wrong tty.

Thanks
Guennadi
---
Guennadi Liakhovetski
