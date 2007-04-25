Return-Path: <linux-kernel-owner+w=401wt.eu-S2992659AbXDYLIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992659AbXDYLIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992663AbXDYLIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:08:38 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992659AbXDYLIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:08:37 -0400
Date: Wed, 25 Apr 2007 04:06:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Guilherme Schroeder <guilherme@centralinf.com.br>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Mikael Pettersson <mikpe@it.uu.se>,
       ak@suse.de, discuss@x86-64.org, Jeff Chua <jeff.chua.linux@gmail.com>,
       pavel@suse.cz, linux-pm@lists.linux-foundation.org,
       Dave Jones <davej@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@infradead.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Dmitry Torokhov <dtor@insightbb.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [3/3] 2.6.21-rc7: known regressions (v2)
Message-Id: <20070425040605.6d6b4a82.akpm@linux-foundation.org>
In-Reply-To: <20070423214909.GD3468@stusta.de>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
	<20070423214909.GD3468@stusta.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 23:49:09 +0200 Adrian Bunk <bunk@stusta.de> wrote:

> This email lists some known regressions in Linus' tree compared to 2.6.20.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way
> possibly involved with one or more of these issues.
> 
> Due to the huge amount of recipients, please trim the Cc when answering.
> 
> 
> Subject    : HPET enabled freeze my machine at boot
>              workaround: clocksource=acpi_pm
> References : http://lkml.org/lkml/2007/4/19/370
> Submitter  : Guilherme Schroeder <guilherme@centralinf.com.br>
> Caused-By  : Thomas Gleixner <tglx@linutronix.de>
>              commit 5d8b34fdcb384161552d01ee8f34af5ff11f9684
> Handled-By : John Stultz <johnstul@us.ibm.com>
> Status     : problem is being debugged
> 
> 
> Subject    : acpi_pm clocksource loses time on x86-64
> References : http://lkml.org/lkml/2007/4/17/143
> Submitter  : Mikael Pettersson <mikpe@it.uu.se>
> Handled-By : John Stultz <johnstul@us.ibm.com>
> Status     : problem is being debugged
> 
> 
> Subject    : suspend to disk hangs  (CONFIG_NO_HZ)
> References : http://lkml.org/lkml/2007/3/25/217
> Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
> Status     : unknown

That's still rather a lot of bustage from the timekeeping changes.  Is
anything really happening here or have we all given up?

> 
> Subject    : ThinkPad X60: resume no longer works  (PCI related?)
>              workaround: CONFIG_FB_BACKLIGHT=n
> References : http://lkml.org/lkml/2007/3/13/3
> Submitter  : Dave Jones <davej@redhat.com>
> Caused-By  : PCI merge
>              commit 78149df6d565c36675463352d0bfe0000b02b7a7
> Handled-By : Eric W. Biederman <ebiederm@xmission.com>
>              Rafael J. Wysocki <rjw@sisk.pl>
>              Antonino A. Daplas <adaplas@gmail.com>
> Status     : unknown
> 

Is this related to the problems Jeremy has been looking at?

> Subject    : suspend to disk works only once
>              workaround: "echo shutdown > /sys/power/disk"
> References : http://lkml.org/lkml/2007/4/13/240
> Submitter  : Tobias Diedrich <ranma+kernel@tdiedrich.de>
> Caused-By  : Rafael J. Wysocki <rjw@sisk.pl>
>              commit ed746e3b18f4df18afa3763155972c5835f284c5
> Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
>              Dmitry Torokhov <dtor@insightbb.com>
> Status     : problem is being debugged

That's been happening on my Vaio-of-death for several weeks now.  I spent a
bit of time with the ACPI guys on it but we didn't get far.  I need to
find an hour or two to work out what's gone wrong.
