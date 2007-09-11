Return-Path: <linux-kernel-owner+w=401wt.eu-S933662AbXIKTkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662AbXIKTkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762658AbXIKTki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:40:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60055 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762568AbXIKTkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:40:37 -0400
Date: Tue, 11 Sep 2007 12:39:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: clockevents: fix resume logic
Message-Id: <20070911123905.2508e4d2.akpm@linux-foundation.org>
In-Reply-To: <200709112135.16639.rjw@sisk.pl>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	<200709111409.13796.rjw@sisk.pl>
	<20070911112531.80bac380.akpm@linux-foundation.org>
	<200709112135.16639.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 21:35:15 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > dmesg without the cpuidle patch: http://userweb.kernel.org/~akpm/dmesg-bad.txt
> > dmesg with the cpuidle patch: http://userweb.kernel.org/~akpm/dmesg-good.txt
> > difference: http://userweb.kernel.org/~akpm/dmesg-diff.txt
> > 
> > there doesn't seem to be a lot of difference in the time handling, except
> > there are large changes in when things happen in the bootup sequence.
> 
> Hm, these things look like they may be related to the suspend/resume problems:
> 
> +Marking TSC unstable due to: possible TSC halt in C2.
> 
> +Clocksource tsc unstable (delta = -458965792 ns)

sort-of.  But look:

akpm:/home/akpm> grep -i tsc dmesg-diff.txt 
+Marking TSC unstable due to: possible TSC halt in C2.
+Clocksource tsc unstable (delta = -458965792 ns)
-Marking TSC unstable due to: cpufreq changes.
-Clocksource tsc unstable (delta = -150503296 ns)

the good and bad kernels seem to be doing quite similar things with the
time management.  But they're doing it at quite different places in the
boot process.

