Return-Path: <linux-kernel-owner+w=401wt.eu-S1762239AbZBYJ7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239AbZBYJ7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761944AbZBYJ7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:59:03 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58708 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1762119AbZBYJ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:59:00 -0500
Date: Wed, 25 Feb 2009 10:58:57 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Brad Boyer <flar@allandria.com>
cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Richard Zidlicky <rz@linux-m68k.org>, rtc-linux@googlegroups.com,
       linux-parisc@vger.kernel.org, David@ozlabs.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Woodhouse <dwmw2@infradead.org>
Subject: Re: [rtc-linux] Re: [PATCH/RFC 0/5] Generic RTC class driver
In-Reply-To: <20090225011426.GB9362@cynthia.pants.nu>
Message-ID: <alpine.LRH.2.00.0902251055260.4063@vixen.sonytel.be>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090220170454.04382e9e@i1501.lan.towertech.it> <alpine.LRH.2.00.0902231319170.22762@vixen.sonytel.be> <20090223160506.04e347c7@i1501.lan.towertech.it>
 <alpine.LRH.2.00.0902241848500.544@vixen.sonytel.be> <20090224193708.5f8be86c@i1501.lan.towertech.it> <20090225011426.GB9362@cynthia.pants.nu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Brad Boyer wrote:
> On Tue, Feb 24, 2009 at 07:37:08PM +0100, Alessandro Zummo wrote:
> > On Tue, 24 Feb 2009 18:56:03 +0100 (CET)
> > Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> > > Converting all (ca. 20?) ppc and m68k RTC support code into individual RTC
> > > class drivers would add ca. 100+ lines of code for each individual driver.
> > 
> >  How different are all of those boards? It's simply a matter
> >  of parameters and offsets? can we group them somehow?
> 
> I imagine we could cut down the numbers somewhat with clever code sharing,
> but it's still going to be a fairly large number. I don't know all the
> embedded boards, but just with all the Macintosh models there are at
> least three and maybe four drastically different methods of RTC access,
> and all of them are directly tied to some chip that does something else
> completely unrelated. For one of them we don't even have a driver at the

Yeah, on Mac/m68k the RTC is usually handled by a chip that does lots of other
things, so you need to keep the bulk of the code in arch/m68k/ anyway.

> moment.  They also are all custom chips that wouldn't be used anywhere
> else. The other thing we need to keep in mind is that if we do it right
> we can share drivers across m68k and powerpc in some cases.  I imagine
> some of the embedded powerpc boards are using chips that are common in
> other architectures as well.

Many embedded powerpc boards already have RTC class drivers under drivers/rtc/,
as their RTC chips are sufficiently common.

The ones that don't are mostly "workstation" or "server" type hardware. The
full list is:
  - rtas_set_rtc_time
  - mpc8xx_set_rtc_time
  - beat_get_rtc_time
  - chrp_set_rtc_time
  - iSeries_set_rtc_time
  - maple_set_rtc_time
  - pmac_set_rtc_time
  - ps3_set_rtc_time

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
