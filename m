Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141Ab0AGLCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab0AGLCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 06:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113Ab0AGLCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 06:02:43 -0500
Received: from dan.rpsys.net ([93.97.175.187]:49942 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab0AGLCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 06:02:42 -0500
X-Greylist: delayed 770 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2010 06:02:42 EST
Subject: Re: 2.6.33-rc3 regression: leds_alix2: can't allocate I/O for GPIO
From: Richard Purdie <rpurdie@rpsys.net>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Daniel Mack <daniel@caiaq.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-geode@lists.infradead.org
In-Reply-To: <4B45B6DD.4060903@nets.rwth-aachen.de>
References: <4B45B6DD.4060903@nets.rwth-aachen.de>
Content-Type: text/plain
Date: Thu, 07 Jan 2010 10:51:24 +0000
Message-Id: <1262861484.8493.14.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 11:26 +0100, Arnd Hannemann wrote:
> with 2.6.33-rc3 the LEDs are not working anymore on my Geode embedded board:
> If I remember correctly this was working fine with 2.6.32, but certainly with 2.6.31
> 
> relevant dmesg output of 2.6.33-rc3:
> 
> [    0.709643] cs5535_gpio: base=0x6100 mask=0xb003c66 major=253
> 
> [    2.207947] leds_alix2: system is recognized as "PC Engines ALIX.2 v0.99h"
> [    2.228678] leds_alix2: can't allocate I/O for GPIO
> 
> 
> For reference dmesg of 2.6.31.3:
> 
> [    0.611953] cs5535_gpio: base=0x6100 mask=0xb003c66 major=253
> 
> [    2.379114] leds_alix2: system is recognized as "PC Engines ALIX.2"
> [    2.399097] Registered led device: alix:1
> [    2.411404] Registered led device: alix:2
> [    2.423720] Registered led device: alix:3

Its likely to be commit 7f131cf3ed96c969d7b092bf629e25c3df50901e. It
looks like the request_region() call is failing. Daniel, any idea why?

Cheers,

Richard

