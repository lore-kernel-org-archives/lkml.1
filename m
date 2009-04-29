Return-Path: <linux-kernel-owner+w=401wt.eu-S1760980AbZD2TsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980AbZD2TsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760880AbZD2Trp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:47:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42424 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760871AbZD2Trp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:47:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: [warn_once] warning: at kernel/hrtimer.c:625 hres_timers_resume+0x24/0x38()
Date: Wed, 29 Apr 2009 21:47:01 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <208cbae30904190953t58105f13p6e11efca6d6f5322@mail.gmail.com> <200904272335.33060.rjw@sisk.pl> <208cbae30904290621m1fbf7bc5x27fa410a23ada3dc@mail.gmail.com>
In-Reply-To: <208cbae30904290621m1fbf7bc5x27fa410a23ada3dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904292147.02441.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009, Alexey Klimov wrote:
> Hello,
> 
> On Tue, Apr 28, 2009 at 1:35 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday 19 April 2009, Alexey Klimov wrote:
> >> Hello all
> >> When testing behaviour of radio-mr800 drvier when doing suspend/resume
> >> to disk, using echo disk > /sys/power/state i have such warning in
> >> dmesg(see below please).
> >> Kernel is 30-rc2, up-to-date. If you need more information, feel free to ask.
> >
> > Can you please retest with the appended patch applied and report back?
> 
> Of course. I applied your patch against up-to-date sources (30-rc3),
> and have more messages after resume:

Thanks!
 
> ACPI: Preparing to enter system sleep state S4
> PM: Saving platform NVS memory
> ------------[ cut here ]------------
> WARNING: at drivers/base/sys.c:405 sysdev_suspend+0xb6/0x21c()
> Hardware name: TravelMate 2350
> Interrupts enabled after cpufreq_suspend+0x0/0x113

Well, it looks like cpufreq_suspend() left us with interrupts enabled and
that caused the other warnings to be printed.  Not nice.

What CPU is there in your box?

Rafael
