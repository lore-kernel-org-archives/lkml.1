Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbZBNU1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbZBNU1h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 15:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbZBNU12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 15:27:28 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48840 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbZBNU11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 15:27:27 -0500
Date: Sat, 14 Feb 2009 15:27:19 -0500
From: Andres Salomon <dilinger@queued.net>
To: Alessandro Zummo <azummo-lists@towertech.it>
Cc: jordan@cosmicpenguin.net, "David Brownell" <david-b@pacbell.net>,
       linux-geode@lists.infradead.org, dsaxena@laptop.org,
       "=?UTF-8?B?TWFydGlu?= =?UTF-8?B?LcOJcmlj?= Racine" <q-funk@iki.fi>,
       lkml <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] AMD Geode CS5535/5536 GPIO driver
Message-ID: <20090214152719.1baf52cc@ephemeral>
In-Reply-To: <20090205161007.4d121cbf@i1501.lan.towertech.it>
References: <20090205161007.4d121cbf@i1501.lan.towertech.it>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I'm just now getting around to looking at this.  Why did we move it
from cs553x-gpio.c to geode_32.c?  I have a lemote (longsoon-based) which
uses cs5536:

Linux debian 2.6.27.1 #193 Mon Jan 5 11:14:50 CST 2009 mips64 GNU/Linux

system type             : lemote-notebook
processor               : 0
cpu model               : ICT Loongson-2 V0.3  FPU V0.1
BogoMIPS                : 132.09
wait instruction        : yes
microsecond timers      : yes
tlb_entries             : 64
extra interrupt vector  : no
hardware watchpoint     : no
ASEs implemented        :
shadow register sets    : 1
core                    : 0
VCED exceptions         : not available
VCEI exceptions         : not available


00:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
00:08.0 VGA compatible controller: Silicon Motion, Inc. SM712 LynxEM+ (rev b0)
00:09.0 USB Controller: NEC Corporation USB (rev 44)
00:09.1 USB Controller: NEC Corporation USB 2.0 (rev 05)
00:0e.0 ISA bridge: Advanced Micro Devices [AMD] CS5536 [Geode companion] ISA (rev 03)
00:0e.2 IDE interface: Advanced Micro Devices [AMD] CS5536 [Geode companion] IDE (rev 01)
00:0e.3 Multimedia audio controller: Advanced Micro Devices [AMD] CS5536 [Geode companion] Audio (rev 01)
00:0e.4 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode companion] OHC (rev 02)
00:0e.5 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode companion] EHC (rev 02)
00:0e.6 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode companion] UDC (rev 02)
00:0e.7 USB Controller: Advanced Micro Devices [AMD] CS5536 [Geode companion] UOC (rev 02)

This leads me to believe that the gpio framework should not be
architecture-specific (nor geode-specific).


On Thu, 5 Feb 2009 16:10:07 +0100
Alessandro Zummo <azummo-lists@towertech.it> wrote:

> 
> 
> A GPIO driver for the AMD Geode CS5535/5536 Companion Devices.
> 
> In the release 2 I've addressed all the concerns expressed by the
> various subsys maintainers involved.
> 
> ---
[...]
