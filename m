Return-Path: <linux-kernel-owner+w=401wt.eu-S1761737AbZBYJyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761737AbZBYJyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757642AbZBYJyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:54:37 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58568 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757531AbZBYJyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:54:36 -0500
Date: Wed, 25 Feb 2009 10:54:33 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: David Woodhouse <dwmw2@infradead.org>
cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, Richard Zidlicky <rz@linux-m68k.org>,
       linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       David@ozlabs.org, Kyle McMartin <kyle@mcmartin.ca>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [rtc-linux] [PATCH/RFC 0/5] Generic RTC class driver
In-Reply-To: <1235511327.18632.73.camel@macbook.infradead.org>
Message-ID: <alpine.LRH.2.00.0902251051370.4063@vixen.sonytel.be>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090220170454.04382e9e@i1501.lan.towertech.it> <alpine.LRH.2.00.0902231319170.22762@vixen.sonytel.be> <1235511327.18632.73.camel@macbook.infradead.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009, David Woodhouse wrote:
> On Mon, 2009-02-23 at 13:34 +0100, Geert Uytterhoeven wrote:
> > >    my opinion on this kind of stuff is that I want to avoid the layering
> > >  of implementations under the rtc subsystem. I'd rather prefer that each
> > >  rtc device had its own driver. 
> > >  
> > >   I've made error in the past, by accepting such kind of drivers, and
> > >  would like to avoid that it happens again.
> > 
> > So you want us to kill the ppc_md.[gs]et_rtc_time() [ppc], mach_hwclk() [m68k],
> > mach_gettod() [m68knommu] (and probably a few other) abstractions, and move all
> > RTC code out of arch/ into seperate drivers under drivers/rtc/ instead?
> 
> That's the ideal... although did we get NTP sync working again yet?
> 
> The rtc-ppc driver was intended as a short-term workaround so that we
> can enable the generic RTC class (which was required for PA Semi
> Electra, iirc), and still have stuff work on other platforms.

Sure. The only differences between your rtc-ppc driver and rtc-parisc were:
  - rtc-ppc uses the PPC RTC abstraction (ppc_md.[gs]et_rtc_time()),
    while rtc-parisc uses the genrtc abstraction layer ([gs]et_rtc_time()),
    which is shared by several architectures,
  - rtc-ppc has the platform device built-in in the driver, while rtc-parisc
    relies on the creation of the platform device in platform code.

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
