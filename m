Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbYGWIVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbYGWIVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 04:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbYGWIUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 04:20:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbYGWIUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 04:20:52 -0400
Date: Wed, 23 Jul 2008 01:19:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@suse.cz>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [patch 2.6.26-rc4-git] PM: boot time suspend selftest
Message-Id: <20080723011954.aa7bf26e.akpm@linux-foundation.org>
In-Reply-To: <200805291333.42057.david-b@pacbell.net>
References: <200805291333.42057.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 13:33:41 -0700 David Brownell <david-b@pacbell.net> wrote:

> Boot-time test for system suspend states (STR or standby).  The generic
> RTC framework triggers wakeup alarms, which are used to exit those states.
> 
>   - Measures some aspects of suspend time ... this uses "jiffies" until
>     someone converts it to use a timebase that works properly even while
>     timer IRQs are disabled. 
> 
>   - Triggered by a command line parameter.  By default nothing even
>     vaguely troublesome will happen, but "test_suspend=mem" will give
>     you a brief STR test during system boot.  (Or you may need to use
>     "test_suspend=standby" instead, if your hardware needs that.)
> 
> This isn't without problems.  It fires early enough during boot that for
> example both PCMCIA and MMC stacks have misbehaved.  The workaround in
> those cases was to boot without such media cards inserted.

mips allmodconfig:

kernel/built-in.o(.init.text+0x5b30): In function `test_suspend':
: undefined reference to `rtc_class'
kernel/built-in.o(.init.text+0x5b38): In function `test_suspend':
: undefined reference to `rtc_class'
kernel/built-in.o(.init.text+0x5ba4): In function `test_suspend':
: undefined reference to `rtc_class_open'
kernel/built-in.o(.init.text+0x5c30): In function `test_suspend':
: undefined reference to `rtc_read_time'
kernel/built-in.o(.init.text+0x5d50): In function `test_suspend':
: undefined reference to `rtc_set_alarm'
kernel/built-in.o(.init.text+0x5f6c): In function `test_suspend':
: undefined reference to `rtc_class_close'

some of these are already exported, so something else went wrong.
