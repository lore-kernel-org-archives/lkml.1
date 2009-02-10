Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbZBJB6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbZBJB6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 20:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZBJB6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 20:58:24 -0500
Received: from mga11.intel.com ([192.55.52.93]:28526 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbZBJB6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 20:58:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,183,1233561600"; 
   d="scan'208";a="429625290"
Subject: Re: [APIC] Kernel panic, rsync corruption, intel q8200, 2.6.28-rc8
From: yakui_zhao <yakui.zhao@intel.com>
To: Sam Ruby <rubys@intertwingly.net>
Cc: Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <4990C14B.7060802@intertwingly.net>
References: <4978767D.4060700@intertwingly.net>
	 <20090130000758.1dff0113.akpm@linux-foundation.org>
	 <498885CC.4060509@intertwingly.net>
	 <20090203114849.b661f1ce.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0902032152180.22800@localhost.localdomain>
	 <49890B46.8020308@intertwingly.net>
	 <alpine.LFD.2.00.0902032336000.5607@localhost.localdomain>
	 <4990C14B.7060802@intertwingly.net>
Content-Type: text/plain; charset=utf-8
Organization: Intel Open Source Technology Center
Date: Tue, 10 Feb 2009 10:10:05 +0800
Message-Id: <1234231805.3706.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 07:50 +0800, Sam Ruby wrote:
> Len Brown wrote:
> >>> Do you have a second computer around with a serial port ? If yes, then
> >>> please add the following to the kernel command line:
> >>>
> >>>        earlyprintk=serial,ttyS0,115200 apic=debug
> >>>
> >>> and connect the serial ports with a null modem cable. Fire up a
> >>> terminal program on the second machine and capture the output.
> >> I do have a second computer, and went out and bought a null modem adapter for
> >> my serial cable and connected the two machines.  I've tried installing minicom
> >> and also connecting it to ttyS0 at 115200 baud on the second machine, but when
> >> I boot the first machine I don't see any output on the terminal.
> > 
> > /boot/grub/menu.lst:
> > 
> > serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
> > terminal --timeout=300 serial console
Do you have an opportunity to try the boot option of "acpi=off" as
suggested by Lenb?
     From the log it seems that there exists the following warning
message:
    >﻿MP-BIOS bug: 8254 timer not connected to IO-APIC

    Can you try the following boot options?
    a. acpi_use_timer_override
    b. acpi_skip_timer_override
    c. noapic

    Thanks.
> > 
> > is what I use.
> > 
> > this will give you a prompt from grub even before the kernel boots
> > so you can select (and edit) your kernel via menu over the serial line
> > if you wish.
> 
> I've got that working now.  I used minicom on the remote machine, 
> capturing the output.  You can see me fumbling around, editing the 
> kernel command and booting here:
> 
> http://intertwingly.net/stories/2009/02/09/minicom.out
> 
> While it is difficult to make out what I did given line wrapping, etc, 
> what I started with was:
> 
> /boot/vmlinuz-2.6.27-11-generic 
> root=UUID=4fce230e-fe72-4685-aab0-294ef1c20efa ro noapic quiet splash
> 
> After editing, what I had was
> 
> /boot/vmlinuz-2.6.27-11-generic 
> root=UUID=4fce230e-fe72-4685-aab0-294ef1c20efa ro quiet splash 
> earlyprintk=serial,ttyS0,115200 apic=debug
> 
> As you can see, the last line I saw was "Starting up ...", after which 
> point the "MP-BIOS bug: 8254 timer not connected to IO-APIC" etc output 
> appeared on the monitor that is directly connected to the machine being 
> booted (i.e., this text did not appear on the minicom session).
> 
> > If this doesn't work, then the kernel earlyprintk is unlikely to work 
> > also.
> 
> At the moment, it looks like it works, but earlyprintk does not work for 
> me, at least not on Ubuntu 8.10, kernel 2.6.27-11-generic.
> 
> > Note that there may be some BIOS SETUP options related to the serial port 
> > -- worth checking.
> > 
> > Also, in minicom, be sure to turn off HW flow control
> > 
> > there is a fancy serial console document someplace on this,
> > probably at http://tldp.org/
> 
> As I have managed to get grub to talk to the serial console, I did not 
> explore these options further.  Please let me know if there is something 
> in particular I should explore.
> 
> > good luck,
> > -Len
> 
> - Sam Ruby
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

