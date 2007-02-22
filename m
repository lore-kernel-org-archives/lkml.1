Return-Path: <linux-kernel-owner+w=401wt.eu-S933098AbXBVPzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbXBVPzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933101AbXBVPzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:55:16 -0500
Received: from www.osadl.org ([213.239.205.134]:50470 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933098AbXBVPzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:55:14 -0500
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <45DDB31C.8070306@drzeus.cx>
References: <20070221230409.GA1158@dreamland.darkstar.lan>
	 <1172099859.25076.132.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>
	 <1172150712.3531.265.camel@laptopd505.fenrus.org>
	 <45DDA43A.4030509@drzeus.cx>
	 <1172154034.3531.270.camel@laptopd505.fenrus.org>
	 <45DDADEB.3030309@drzeus.cx>  <45DDB31C.8070306@drzeus.cx>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 17:00:23 +0100
Message-Id: <1172160024.25076.188.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 16:13 +0100, Pierre Ossman wrote:
> > Sure. My dmesg is full of mmc debug crud right now, but I'll just reboot
> > and I'll have a clean one for you.
> > 
> 
> Here we go.

> [   44.498253] ACPI: Lid Switch [C136]
> [   44.577672] No dock devices found.
> [   44.714156] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])

---------------------------------------------------------^^^^^

Here is the reason. The local APIC stops working in C3 state and we fall
back to the PIT in that case. Not really exciting for dynticks, but the
only way to keep the system alive. There is a patch coming up from
Intel, which finds out how to use HPET even if it is not enabled by the
BIOS. This will still end up on IRQ#0, but will give way longer idle
sleeps than the PIT.

	tglx





