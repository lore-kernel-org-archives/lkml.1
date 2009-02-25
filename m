Return-Path: <linux-kernel-owner+w=401wt.eu-S1761908AbZBYJzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761908AbZBYJzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761792AbZBYJy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:54:58 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58585 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761788AbZBYJy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:54:57 -0500
Date: Wed, 25 Feb 2009 10:54:54 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Helge Deller <deller@gmx.de>
cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
       Kyle McMartin <kyle@mcmartin.ca>, David Woodhouse <dwmw2@infradead.org>,
       Richard Zidlicky <rz@linux-m68k.org>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, dann frazier <dannf@dannf.org>
Subject: Re: [PATCH/RFC 0/5] Generic RTC class driver
In-Reply-To: <49A4406F.2010407@gmx.de>
Message-ID: <alpine.LRH.2.00.0902251054371.4063@vixen.sonytel.be>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <49A4406F.2010407@gmx.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Helge Deller wrote:
> Geert Uytterhoeven wrote:
> > I've been looking into problems with auto-loading the RTC driver on PPC (more
> > specifically on PS3):
> >   - The recent "rtc-ppc" RTC class driver is not autoloaded by udev because
> >     it's an old style platform driver that contains its own platform device.
> >   - The alternative old "genrtc" driver is autoloaded on non-udev systems only
> >     because it contains the module alias char-major-10-135. However, it's not
> >     a new-style RTC class driver.
> > 
> > Fortunately there already exists a generic RTC class driver: "rtc-parisc".
> > Despite it's name, it's platform-independent, as it's build on top of the RTC
> > abstraction used by "genrtc".
> > 
> > This patch series
> >   - adds a missing module alias to rtc-parisc,
> >   - renames rtc-parisc to rtc-generic,
> >   - converts the architectures that currently have CONFIG_GEN_RTC enabled in
> >     their defconfig (m68k, parisc, powerpc) to rtc-generic,
> >   - removes the obsolete rtc-ppc driver,
> >   - removes the old genrtc driver.
> >   
> > Note that genrtc may be used on other archictectures as well: at least alpha
> > has the required infrastructure ([gs]et_rtc_time()). The Kconfig rules allow
> > genrtc to be enabled on several others (cris, h8300, mn10300, um, x86, xtensa).
> > 
> > Furthermore genrtc and rtc-generic are not 100% userspace compatible:
> >   - /dev/rtc provided by genrtc uses a misc character device (10:135),
> >   - /dev/rtc provided by rtc-generic uses a dynamic character device.
> >   
> > So perhaps we don't want to kill gen-rtc yet?
> > 
> > Any comments are welcomed!
> 
> Hi Geert,
> FYI, I didn't followed any discussions or changes around the RTC drivers for parisc,
> but Dann Frazier did some work on the parisc RTC driver as well.
> His patches were merged (not upstream yet!) in Kyle's "rtc-parisc" branch at:
> http://git.kernel.org/?p=linux/kernel/git/kyle/parisc-2.6.git;a=shortlog;h=rtc-parisc
> 
> Not sure if they conflict (or are in sync) with your patches...

Thanks, they provide some nice cleanups.

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
