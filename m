Return-Path: <linux-kernel-owner+w=401wt.eu-S1751157AbXBVNZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbXBVNZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 08:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbXBVNZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 08:25:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33134 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbXBVNZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 08:25:19 -0500
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>
References: <20070221230409.GA1158@dreamland.darkstar.lan>
	 <1172099859.25076.132.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Feb 2007 14:25:12 +0100
Message-Id: <1172150712.3531.265.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> What's the benefit of doing so - and why has not it been done before?
> I mean, I run a regular 2.6.18.6,
> /sys/devices/system/clocksource/clocksource0/current_clocksource (is this
> related?) shows "acpi_pm", but the IRQ0 counter increases at HZ. Maybe I
> am confusing things, but why the need for PIT when clocksource is acpi_pm
> anyway?

you're mixing up 2 concepts:
1) clocksource
2) eventsource

1) is for "what time is it now", and acpi_pm is useful for that, as are
several other things such as rdtsc
2) is for "I need THIS to happen X miliseconds from now". acpi_pm is not
useful for that, nor is rdtsc.

some can be used for both (PIT), but on a concept level the uses are
independent. The advantage of local apic over PIT is that local apic is
cheap to do "one shot" future events with, while the PIT will tick
periodic at a fixed frequency. With tickless idle.. that's not what you
want.


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

