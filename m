Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599Ab0AGMqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab0AGMqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 07:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572Ab0AGMqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 07:46:36 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:38167 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab0AGMqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 07:46:35 -0500
Date: Thu, 7 Jan 2010 20:46:30 +0800
From: Daniel Mack <daniel@caiaq.de>
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-geode@lists.infradead.org" <linux-geode@lists.infradead.org>
Subject: Re: 2.6.33-rc3 regression: leds_alix2: can't allocate I/O for GPIO
Message-ID: <20100107124630.GU28375@buzzloop.caiaq.de>
References: <4B45B6DD.4060903@nets.rwth-aachen.de>
 <1262861484.8493.14.camel@dax.rpnet.com>
 <4B45CC4C.4030603@nets.rwth-aachen.de>
 <4B45CF73.9090304@nets.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B45CF73.9090304@nets.rwth-aachen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 01:11:31PM +0100, Arnd Hannemann wrote:
> Arnd Hannemann schrieb:
> > Richard Purdie schrieb:
> >> On Thu, 2010-01-07 at 11:26 +0100, Arnd Hannemann wrote:
> >>> with 2.6.33-rc3 the LEDs are not working anymore on my Geode embedded board:
> >>> If I remember correctly this was working fine with 2.6.32, but certainly with 2.6.31
> >>>
> >>> relevant dmesg output of 2.6.33-rc3:
> >>>
> >>> [    0.709643] cs5535_gpio: base=0x6100 mask=0xb003c66 major=253
> >>>
> >>> [    2.207947] leds_alix2: system is recognized as "PC Engines ALIX.2 v0.99h"
> >>> [    2.228678] leds_alix2: can't allocate I/O for GPIO
> >>>
> >>>
> >>> For reference dmesg of 2.6.31.3:
> >>>
> >>> [    0.611953] cs5535_gpio: base=0x6100 mask=0xb003c66 major=253
> >>>
> >>> [    2.379114] leds_alix2: system is recognized as "PC Engines ALIX.2"
> >>> [    2.399097] Registered led device: alix:1
> >>> [    2.411404] Registered led device: alix:2
> >>> [    2.423720] Registered led device: alix:3
> >> Its likely to be commit 7f131cf3ed96c969d7b092bf629e25c3df50901e. It
> >> looks like the request_region() call is failing. Daniel, any idea why?
> > 
> > Some additional debug information:
> > 
> > elara:~# rdmsr 0x5140000C
> > f00100006100
> > 
> > /proc/ioports says:
> > 6100-61ff : 0000:00:0f.0
> >   6100-61ff : cs5535_gpio
> > 
> > BTW: why is request_region() needed there after all?
> 
> Oh, maybe using cs5535_gpio AND leds_alix2 together was never supposed to work?

That is the problem indeed. The problem is that three of these GPIOs are
connected to LEDs, so if both drivers are enabled, they will both alter
the same GPIOs. Hmm, don't know how to handle this. Maybe the LED driver
should use the GPIO interface and that's it?

Daniel
