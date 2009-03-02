Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbZCBLKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbZCBLKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 06:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbZCBLJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 06:09:57 -0500
Received: from mx0.towertech.it ([213.215.222.73]:51410 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752379AbZCBLJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 06:09:56 -0500
Date: Mon, 2 Mar 2009 12:09:50 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Richard Zidlicky <rz@linux-m68k.org>, rtc-linux@googlegroups.com,
       David Woodhouse <dwmw2@infradead.org>, linux-parisc@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [rtc-linux] Re: [PATCH/RFC 0/5] Generic RTC class driver
Message-ID: <20090302120950.0d35e06c@i1501.lan.towertech.it>
In-Reply-To: <alpine.LRH.2.00.0903021116450.25117@vixen.sonytel.be>
References: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<20090220170454.04382e9e@i1501.lan.towertech.it>
	<alpine.LRH.2.00.0902231319170.22762@vixen.sonytel.be>
	<1235511327.18632.73.camel@macbook.infradead.org>
	<20090224231154.60ba18d6@i1501.lan.towertech.it>
	<1235514727.18632.93.camel@macbook.infradead.org>
	<alpine.LRH.2.00.0902251059110.4063@vixen.sonytel.be>
	<20090225111836.621412c1@i1501.lan.towertech.it>
	<20090227185514.GA1071@linux-m68k.org>
	<alpine.LRH.2.00.0903021051040.25117@vixen.sonytel.be>
	<20090302110310.35af50ea@i1501.lan.towertech.it>
	<alpine.LRH.2.00.0903021116450.25117@vixen.sonytel.be>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 11:28:01 +0100 (CET)
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> So I can solve my problem (autoloading the RTC driver on PS3 by udev) by
> converting the old genrtc driver into a platform device driver and creating
> platform devices where appropriate.

 yes. btw, if you are building a kernel specific for the PS3, I would
 compile the rtc driver statically, otherwise it won't be available
 early on boot.
 
> However, this doesn't solve the distro's problem: as the old RTC framework
> depends on RTC_LIB=n, you cannot have both old and new RTC drivers in your
> (single) distro kernel. That's why dmwm2 created drivers/rtc/rtc-ppc.c: Fedora
> had to support machines with both old and new RTC drivers. As all of the old
> drivers are actually behind the ppc_md.[sg]et_rtc_time() abstraction, this was
> very easy.

 ok, generic kernel. you will have to load the modules on initrd. no, sadly you
 can't have both of them. you might stick with the old interface or
 convert them all. 

> Hence it's all or nothing, and we have to convert all of them.
> 
> drivers/rtc/rtc-generic.c would allow to have a working system without old
> RTC drivers, until all low-level code has been converted to individual RTC
> drivers.

 I know but I have enough experience to foresee that once a generic over generic
 framework is in place it's very hard to get rid of it because people
 will have no incentives.

 If you really need rtc-generic you can keep using it even if it's 
 not in the kernel, distributions often have their specific
 set of kernel patches.

 But I'd strongly suggest to plan and execute a conversion process.


> >  Layering a generic framework over another generic framework
> >  is quite a nonsense . 
> 
> IMHO these two generic frameworks are quite different: [sg]et_rtc_time()
> abstracts the low-level RTC hardware interface, while RTC class handles the
> interaction with userspace.

 When I wrote it my intention was to make it as an abstraction _between_
 the userspace and the hardware according to the platform/device model.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

