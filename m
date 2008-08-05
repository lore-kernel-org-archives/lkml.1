Return-Path: <linux-kernel-owner+w=401wt.eu-S1762741AbYHEWQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762741AbYHEWQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 18:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYHEWQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 18:16:39 -0400
Received: from web82105.mail.mud.yahoo.com ([209.191.84.218]:37135 "HELO
	web82105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752088AbYHEWQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 18:16:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=DvdeBtlKX3wv6FLT26dtZiiC9RTtjw7DW9rl83KIMOQLOUQlTM7mw8ZNyNf1KJYG2Dh7ePrxAK2IhjSOeTt5ifKiojXX3AYsH9wskh7I1Fa9UW48os51UEeZo6qt0Z+hZdx9repFhnsI6kV9/YgmXlG4WdpNpyogIuZ0plc5Va4=;
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218
Date: Tue, 5 Aug 2008 15:16:37 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25
To: linux-kernel@vger.kernel.org
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <502507.7481.qm@web82105.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> please boot with "debug apic=verbose initcall_debut" to check exactly
> where it hangs...

In my OP, I mentioned that I submitted a bug report to the Debian BTS
before coming to LKML.  I hoped to keep the bug an internal Debian matter,
since the kernels I compile were always from Debianized kernel sources.

Below I comply with your request, booting the kernel built from the HEAD
of the git tree I downloaded yesterday, dated 
    Fri Aug 1 14:59:11 2008 -0700

and with commit ID
    2b12a4c524812fb3f6ee590a02e65b95c8c32229


Before continuing, I would like to mention that in my original post to
the Debian BTS, I reported the last lines on the screen for several
kernels booted with "debug earlyprink=vga initcall_debug loglevel=7".
I originally thought I was to blame -- some error in my '.config' --
so, unfortunately, I made a lot of irrelevant noise in the Debian BTS
thread as I scrambled to determine the cause of the freeze.  So maybe
the info there is not useful at all, but here is the link again, 
Just In Case:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=493479


OK, now booting 2.6.27-rc1 with "ro debug apic=verbose initcall_debug"...
Here is the last visible output before the freeze:
=========================================

calling chr_dev_init+0x0/0xa2
initcall chr_dev_init returned 0 after 0 msecs
calling firmware_class_init+0x0/0x71
initcall firmware_class_init returned 0 after 0 msecs
calling loopback_init+0x0/0xc
initcall loopback_init returned 0 after 0 msecs
calling cpufreq_gov_performance_init+0x0/0xc
initcall cpufreq_gov_performance_init returned 0 after 0 msecs
calling init_acpi_pm_clocksource+0x0/0xb4
initcall init_acpi_pm_clocksource returned 0 after 0 msecs
calling pci_bios_assign_resources+0x0/0x8b
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xe000-0xefff
pci 0000:00:01.0:   MEM window: 0xfdd00000-0xfdefffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d8000000-0x000000dfffffff
pci 0000:00:14.4: PCI bridge, secondary bus 0000:02
pci 0000:00:14.4:   IO window: 0xd000-0xdfff
pci 0000:00:14.4:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:00:14.4:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
initcall pci_bios_assign_resources returned 0 after 285696 msecs
calling inet_init+0x0/0x250
NET: Registered protocol family 2
=========================================

I can tell you that the "285696" figure is way off if "msecs" is
supposed to mean milliseconds.  It might be accurate if microseconds
are intended, but the entire process from GRUB handing off to the
kernel until the freeze occurs is just a few moments:  3 seconds at
the most, probably less.

This info was copied by hand.  I had no other way to transfer the info
into this post, so I apologize in advance for any errors.  I did
double check it, but some of those hex values are typos waiting to
happen....  (I'm pretty sure I got them right, though  ;)

Only 3 files were impacted by the commit that is causing the freeze
for my machine with the ECS mboard.  If you would like to give me
some code to insert in those files (or other files) that would 
print more helpful output during the boot, I would be more than
happy to give it a try.


Dave W.
