Return-Path: <linux-kernel-owner+w=401wt.eu-S1752421AbXCaVXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbXCaVXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 17:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXCaVXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 17:23:38 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39512 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752421AbXCaVXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 17:23:37 -0400
Date: Sat, 31 Mar 2007 23:23:37 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Pavel Machek <pavel@ucw.cz>, Maxim <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Fix microcode-related suspend problem
Message-ID: <20070331212337.GF14134@stusta.de>
References: <200703312204.15752.rjw@sisk.pl> <20070331133532.0d791f6e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070331133532.0d791f6e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 01:35:32PM -0700, Andrew Morton wrote:
> On Sat, 31 Mar 2007 22:04:15 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This patch appeard on LMKL six days ago and there have not been any negative
> > comments since then, so I think I can try to make it official.
> > 
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Fix the regression resulting from the recent change of suspend code ordering
> > that causes systems based on Intel x86 CPUs using the microcode driver to
> > hang during the resume.
> > 
> > The problem occurs since the microcode driver uses request_firmware() in its
> > CPU hotplug notifier, which is called after tasks has been frozen and hangs.
> > It can be fixed by telling the microcode driver to use the microcode stored in
> > memory during the resume instead of trying to load it from disk.
> 
> CONFIG_SMP=n:
> 
> arch/i386/kernel/microcode.c: In function 'microcode_init_cpu':
> arch/i386/kernel/microcode.c:628: error: 'suspend_cpu_hotplug' undeclared (first use in this function)
> arch/i386/kernel/microcode.c:628: error: (Each undeclared identifier is reported only once
> arch/i386/kernel/microcode.c:628: error: for each function it appears in.)
> arch/i386/kernel/microcode.c: In function 'mc_sysdev_add':
> arch/i386/kernel/microcode.c:717: error: 'suspend_cpu_hotplug' undeclared (first use in this function)
> arch/i386/kernel/microcode.c: In function 'mc_sysdev_remove':
> arch/i386/kernel/microcode.c:745: error: 'suspend_cpu_hotplug' undeclared (first use in this function)
> 
> Given this, and the overall intrusiveness of the change, I'd worry about
> trying to get this into 2.6.21.

It fixes a regression, and we are still at least one month away from the 
release of 2.6.21.

2.6.20 was released with too many known regressions [1], let's not 
repeat this mistake with 2.6.21.

cu
Adrian

[1] at least the CONFIG_USB_SUSPEND powerdown regression and the
    pktcdvd+libata not working regression shouldn't have been in
    a released kernel

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

