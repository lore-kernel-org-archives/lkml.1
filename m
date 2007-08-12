Return-Path: <linux-kernel-owner+w=401wt.eu-S932157AbXHLI3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbXHLI3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 04:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbXHLI3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 04:29:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756850AbXHLI3R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 04:29:17 -0400
Date: Sun, 12 Aug 2007 01:28:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?IklscG8gSuRydmluZW4i?= <ilpo.jarvinen@helsinki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.23-rc2 locks up during boot (without acpi=off)
Message-Id: <20070812012826.cfc9f5bb.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708012131480.1479@kivilampi-30.cs.helsinki.fi>
References: <Pine.LNX.4.64.0708012131480.1479@kivilampi-30.cs.helsinki.fi>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Aug 2007 15:39:30 +0300 (EEST) "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi> wrote:

> I noticed that v2.6.23-rc1 locks up during boot, same thing happens now 
> with the latest linus' tree (+net-2.6.24 and tcp-2.6 tree stuff on top 
> of it; in -rc1 test they weren't though). The exact location of hang
> varies a bit though. No OOPS, does not respond to sysrq or anything else 
> besides reset. Last known bootable one is something like 2.6.22-rc4 
> (I usually run 2.6.21.5 on this machine, haven't tried any 2.6.22 on
> this after those rcs). Problem seems to start after this line:
> 
> Time: acpi_pm clocksource has been installed.
> 
> ...the power led starts blinking (not periodic cycle but more or less 
> varying on-off cycle, never seen that led blink before at all, didn't know 
> that one can make it blink :-)) and the machine gets consideably slower 
> too. Never have it been able to complete booting all they way up to login 
> prompt before lock up.
> 
> Tried with acpi=off, boots just fine (dmesg comes from it). I can take 

A hang a short-but-variable period after a clocksource was installed: probably
means that the kernel wedged on the first clock interrupt.

I'd expect 2.6.22 to work OK.  It's a little unexpected that the bug was added
after 2.6.22: a number of these reports have narrowed down to the patchset which
added dynticks and clockevents, but that was already in 2.6.22.

It'd be great if you could run a git bisection search please.
