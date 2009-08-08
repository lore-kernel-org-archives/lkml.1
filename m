Return-Path: <linux-kernel-owner+w=401wt.eu-S933986AbZHHJt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933986AbZHHJt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 05:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933973AbZHHJt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 05:49:56 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:34831 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933953AbZHHJtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 05:49:50 -0400
Date: Sat, 08 Aug 2009 11:49:50 +0200
Message-Id: <859414371@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org, Martin Rogge <marogge@onlinehome.de>
Subject: Re: 2.6.30.1-4 kernels freezes dual pentium-3 system
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1871PfUrJ2OW2k2UtZ4xcQrJfsdpCPrs0rn0aRVYxBKgB80V
 AzB/TN+/u/I8R+KplRZEvdHz97bX1/hOAVog28OqfLEFp7loX0=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Roland, you seem to reply to a mix of different mails.

i replied to this thread:
http://marc.info/?t=124928942600006&r=1&w=2

> I skip the comments 
> unrelated to my error report. Btw, since then there have been two more reports 
> on lkml of dual P2 systems locking up with 2.6.30++.

could you send pointers? 
any existing bugzilla bugentry for these or for your`s ? 

> > afaik, you can also bisect on a different (i.e. faster) box.
> 
> Since we are talking about dual-P3, no you can't.

ok, i missed your comment regarding duration of bisect iteration. 
but despite that, compiling on another/faster box and copy the kernel over is possible, 
afaik (and won`t help here) 

> > i think it would be more interesting if there is anything in dmesg on such
> 
> I posted dmesg etc. yesterday

yes, but that mostly contain bootup messages and there`s absolutely no trace from 
the freeze. it`s quite common, that after a lockup/crash some messages are lost, 
that`s why i asked if there is a chance to have serial console or netconsole attached. 

> Network, sysrq and numlock are all unresponsive. 
ok, that`s why we need to have the last informations from before the dying breath... 

btw, i one of your dmesg i found these:

Aug  1 19:42:57 frya kernel: [    0.000000] Linux version 2.6.30-gentoo-r4 \

Aug  1 19:42:57 frya kernel: [    4.394755] ------------[ cut here ]------------
Aug  1 19:42:57 frya kernel: [    4.399247] WARNING: at arch/x86/mm/ioremap.c:603 \
                check_early_ioremap_leak+0x53/0x73()
Aug  1 19:42:57 frya kernel: [    4.408763] Hardware name: System Name
Aug  1 19:42:57 frya kernel: [    4.413574] Debug warning: early ioremap leak of 1 \
                areas detected.
Aug  1 19:42:57 frya kernel: [    4.418561] Pid: 1, comm: swapper Not tainted \
                2.6.30-gentoo-r4 #1
Aug  1 19:42:57 frya kernel: [    4.423552] Call Trace:
Aug  1 19:42:57 frya kernel: [    4.428379]  [<c07c90b2>] ? \
                check_early_ioremap_leak+0x53/0x73
Aug  1 19:42:57 frya kernel: [    4.433238]  [<c07c90b2>] ? \
                check_early_ioremap_leak+0x53/0x73
Aug  1 19:42:57 frya kernel: [    4.437821]  [<c01316ac>] \
                warn_slowpath_common+0x6c/0xc0
Aug  1 19:42:57 frya kernel: [    4.442266]  [<c07c90b2>] ? \
                check_early_ioremap_leak+0x53/0x73
Aug  1 19:42:57 frya kernel: [    4.446658]  [<c07c905f>] ? \
                check_early_ioremap_leak+0x0/0x73
Aug  1 19:42:57 frya kernel: [    4.450880]  [<c013174b>] warn_slowpath_fmt+0x2b/0x30
Aug  1 19:42:57 frya kernel: [    4.455062]  [<c07c90b2>] \
                check_early_ioremap_leak+0x53/0x73
Aug  1 19:42:57 frya kernel: [    4.459288]  [<c010103f>] do_one_initcall+0x2f/0x160
Aug  1 19:42:57 frya kernel: [    4.463528]  [<c01e3d3a>] ? \
                create_proc_entry+0x5a/0xb0
Aug  1 19:42:57 frya kernel: [    4.467751]  [<c015cfe5>] ? \
                register_irq_proc+0xa5/0xc0
Aug  1 19:42:57 frya kernel: [    4.471924]  [<c015a1a8>] ? irq_to_desc+0x8/0x40
Aug  1 19:42:57 frya kernel: [    4.476110]  [<c015d075>] ? init_irq_proc+0x75/0x90
Aug  1 19:42:57 frya kernel: [    4.480343]  [<c07b95b5>] kernel_init+0x122/0x179
Aug  1 19:42:57 frya kernel: [    4.484616]  [<c07b9493>] ? kernel_init+0x0/0x179
Aug  1 19:42:57 frya kernel: [    4.488860]  [<c010397f>] \
                kernel_thread_helper+0x7/0x10
Aug  1 19:42:57 frya kernel: [    4.493137] ---[ end trace d2a1e0f2aa8609d9 ]---
Aug  1 19:42:57 frya kernel: [    4.497524] please boot with early_ioremap_debug and \
                report the dmesg.


and:

Aug  1 19:42:57 frya kernel: [    0.121015] * The chipset may have PM-Timer Bug. Due \
                to workarounds for a bug,
Aug  1 19:42:57 frya kernel: [    0.121020] * this clock source is slow. If you are \
                sure your timer does not have
Aug  1 19:42:57 frya kernel: [    0.121024] * this bug, please use "acpi_pm_good" to \
                disable the workaround
Aug  1 19:42:57 frya kernel: [    0.121563] * The chipset may have PM-Timer Bug. Due \
                to workarounds for a bug,
Aug  1 19:42:57 frya kernel: [    0.121568] * this clock source is slow. If you are \
                sure your timer does not have
Aug  1 19:42:57 frya kernel: [    0.121572] * this bug, please use "acpi_pm_good" to \
                disable the workaround


maybe it`s worth having a look at (on 2.6.29 and 2.6.30 system)
 
/sys/devices/system/clocksource/clocksource0/current_clocksource
/sys/devices/system/clocksource/clocksource0/available_clocksource

and/or try specific clocksources with "clocksource=...." on boot (to see if it makes a
difference). I have seen system freeze when the kernel detected an unstable 
clocksource and dynamically switched to another (more stable) one.

roland
________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

