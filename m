Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZCDI0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZCDI0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 03:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZCDI0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 03:26:34 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43166 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751829AbZCDI0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 03:26:33 -0500
Date: Wed, 4 Mar 2009 09:26:29 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Paul Mundt <lethal@linux-sh.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       Richard Zidlicky <rz@linux-m68k.org>, rtc-linux@googlegroups.com,
       linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [rtc-linux] Re: [PATCH/RFC 0/5] Generic RTC class driver
In-Reply-To: <20090303190609.GB6907@linux-sh.org>
Message-ID: <alpine.LRH.2.00.0903040920240.2416@vixen.sonytel.be>
References: <20090224231154.60ba18d6@i1501.lan.towertech.it> <1235514727.18632.93.camel@macbook.infradead.org> <alpine.LRH.2.00.0902251059110.4063@vixen.sonytel.be> <20090225111836.621412c1@i1501.lan.towertech.it> <20090227185514.GA1071@linux-m68k.org>
 <alpine.LRH.2.00.0903021051040.25117@vixen.sonytel.be> <20090302110310.35af50ea@i1501.lan.towertech.it> <alpine.LRH.2.00.0903021116450.25117@vixen.sonytel.be> <20090302120950.0d35e06c@i1501.lan.towertech.it> <alpine.LRH.2.00.0903031121280.31985@vixen.sonytel.be>
 <20090303190609.GB6907@linux-sh.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009, Paul Mundt wrote:
> On Tue, Mar 03, 2009 at 11:41:23AM +0100, Geert Uytterhoeven wrote:
> > So would you accept a patch series that:
> >   1. Adds the missing module aliases to rtc-parisc (which is a bugfix),
> >   2. Moves the platform device creation out of rtc-ppc and into arch-specific
> >      code (which is also a bugfix),
> >   3. Consolidates rtc-parisc and rtc-ppc into rtc-generic (which is a cleanup),
> >   4. Makes rtc-generic dependent on PARISC, PPC, and M68K (the existing
> >      [sg]et_rtc_time() users):
> >        a. without introducing ARCH_HAS_GENERIC_RTC,
> >        b. with a big fat warning in the Kconfig comment not relaxing the
> >           dependencies, as it's supposed to go away.
> >   4. Converts the PS3 RTC support into a separate driver, called rtc-ps3
> >      (as a bonus ;-)
> > 
> > ? If yes, I'll cook it up.
> > 
> > Other RTC platform support can be converted into separate drivers later.
> > 
> Did you miss the rtc-firmware thread?
> 
> http://groups.google.com/group/rtc-linux/browse_thread/thread/53e8d98966048f66/1d730cb4aa2f85f0?lnk=gst&q=rtc-firmware#1d730cb4aa2f85f0
> http://groups.google.com/group/rtc-linux/browse_thread/thread/b3d10115c7e147f2/cb9c1530d9c3a433?lnk=gst&q=rtc-firmware#cb9c1530d9c3a433

Thanks Paul, I wasn't aware of that thread!

Yes, this is almost the same. The only part I don't agree with is the move of
the creation of the platform device from arch-specific code to rtc-firmware.c,
as this makes autoloading the driver more difficult.

Seems like everybody but the RTC maintainer has an interest in having an RTC
class driver on top of [gs]et_rtc_time()... ;-)

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
