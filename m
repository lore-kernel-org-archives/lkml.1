Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbZBWPF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbZBWPF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbZBWPFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:05:11 -0500
Received: from mx0.towertech.it ([213.215.222.73]:46160 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754578AbZBWPFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:05:10 -0500
Date: Mon, 23 Feb 2009 16:05:06 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: Geert.Uytterhoeven@sonycom.com, Richard Zidlicky <rz@linux-m68k.org>,
       linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David@ozlabs.org, Kyle McMartin <kyle@mcmartin.ca>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Woodhouse <dwmw2@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [rtc-linux] Re: [PATCH/RFC 0/5] Generic RTC class driver
Message-ID: <20090223160506.04e347c7@i1501.lan.towertech.it>
In-Reply-To: <alpine.LRH.2.00.0902231319170.22762@vixen.sonytel.be>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<20090220170454.04382e9e@i1501.lan.towertech.it>
	<alpine.LRH.2.00.0902231319170.22762@vixen.sonytel.be>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 13:34:49 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> >  Hello,
> > 
> >    my opinion on this kind of stuff is that I want to avoid the layering
> >  of implementations under the rtc subsystem. I'd rather prefer that each
> >  rtc device had its own driver. 
> >  
> >   I've made error in the past, by accepting such kind of drivers, and
> >  would like to avoid that it happens again.
> 
> So you want us to kill the ppc_md.[gs]et_rtc_time() [ppc], mach_hwclk() [m68k],
> mach_gettod() [m68knommu] (and probably a few other) abstractions, and move all
> RTC code out of arch/ into seperate drivers under drivers/rtc/ instead?

 not all at once :) 

 I'd start writing a working driver and then see how we should eventually
 adapt the rtc subsystem to cope with your needs.
 
> What about ppc_md.get_boot_time() [ppc]?
> Please note that the functions above may also be used for very early clock
> setting (e.g. time_init()) and in read_persistent_clock().
> How should we handle these?

 read_persistent_clock is something that should be reconsidered
 as well along with all the ntp stuff.

> Even on x86 there seems to be way too much RTC logic in arch/x86/kernel/rtc.c

> (e.g. mach_get_cmos_time()), which is duplicated in drivers/rtc/rtc-cmos.c
> through the inline function __get_rtc_time() in include/asm-generic/rtc.h
> (clever, hardware-specific stuff in asm-generic ;-)

 yep, I know :( that hardcoded rtc stuff seems to be everywhere!


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

