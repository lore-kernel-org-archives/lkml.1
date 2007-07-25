Return-Path: <linux-kernel-owner+w=401wt.eu-S1759910AbXGYFnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759910AbXGYFnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 01:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbXGYFmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 01:42:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbXGYFmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 01:42:52 -0400
Date: Tue, 24 Jul 2007 22:42:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Wise <jwise@google.com>
Cc: linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>,
       Mike Waychison <mikew@google.com>,
       Masoud Asgharifard Sharbiani <masouds@google.com>,
       Andrew Morton <akpm@google.com>
Subject: Re: [PATCH] Print utsname on Oops on all architectures
Message-Id: <20070724224209.5dd511b3.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707051847030.617@internets.corp.google.com>
References: <Pine.LNX.4.64.0707051847030.617@internets.corp.google.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2007 18:52:27 -0700 (PDT) Joshua Wise <jwise@google.com> wrote:

> Background:
>  This patch is a follow-on to "Info dump on Oops or panic()" [1].
>  
>  On some architectures, the kernel printed some information on the running
>  kernel, but not on all architectures. The information printed was generally
>  the version and build number, but it was not located in a consistant place,
>  and some architectures did not print it at all.
> 
> Description:
>  This patch uses the already-existing die_chain to print utsname information
>  on Oops. This patch also removes the architecture-specific utsname
>  printers. To avoid crashing the system further (and hence not printing the
>  Oops) in the case where the system is so hopelessly smashed that utsname
>  might be destroyed, we vsprintf the utsname data into a static buffer
>  first, and then just print that on crash.
> 
> Testing:
>  I wrote a module that does a *(int*)0 = 0; and observed that I got my
>  utsname data printed.
> 
> Potential impact:
>  This adds another line to the Oops output, causing the first few lines to
>  potentially scroll off the screen. This also adds a few more pointer
>  dereferences in the Oops path, because it adds to the die_chain notifier
>  chain, reducing the likelihood that the Oops will be printed if there is
>  very bad memory corruption.

There are strange happenings due to this patch on i386:

Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
hdc: max request size: 128KiB
hdc: 156355584 sectors (80054 MB) w/1819KiB Cache, CHS=65535/16/63, UDMA(33)
hdc: cache flushes supported
 hdc:<0>Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
 hdc1 hdc2 hdc3 hdc4 <<0>Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
 hdc5<0>Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
 hdc6 >
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
initcall 0xc052a060: idedisk_init+0x0/0x10() returned 0.
initcall 0xc052a060 ran for 38 msecs: idedisk_init+0x0/0x10()
Calling initcall 0xc052a070: ide_cdrom_init+0x0/0x10()
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
initcall 0xc052a070: ide_cdrom_init+0x0/0x10() returned 0.
initcall 0xc052a070 ran for 3 msecs: ide_cdrom_init+0x0/0x10()
Calling initcall 0xc052a080: idetape_init+0x0/0x90()
initcall 0xc052a080: idetape_init+0x0/0x90() returned 0.
initcall 0xc052a080 ran for 0 msecs: idetape_init+0x0/0x90()
Calling initcall 0xc052a110: idefloppy_init+0x0/0x20()
ide-floppy driver 0.99.newide
initcall 0xc052a110: idefloppy_init+0x0/0x20() returned 0.
initcall 0xc052a110 ran for 0 msecs: idefloppy_init+0x0/0x20()
Calling initcall 0xc052a3e0: spi_transport_init+0x0/0x30()
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
Linux 2.6.23-rc1-mm1 #7 SMP Tue Jul 24 22:34:40 PDT 2007 i686
initcall 0xc052a3e0: spi_transport_init+0x0/0x30() returned 0.
initcall 0xc052a3e0 ran for 3 msecs: spi_transport_init+0x0/0x30()
Calling initcall 0xc052a410: fc_transport_init+0x0/0x50()
initcall 0xc052a410: fc_transport_init+0x0/0x50() returned 0.
initcall 0xc052a410 ran for 0 msecs: fc_transport_init+0x0/0x50()
Calling initcall 0xc052a460: init_sd+0x0/0x90()
initcall 0xc052a460: init_sd+0x0/0x90() returned 0.
initcall 0xc052a460 ran for 0 msecs: init_sd+0x0/0x90()

and it gets no further.

I'll drop it - let's start again?
