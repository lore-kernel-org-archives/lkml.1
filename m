Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbZIXW2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbZIXW2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 18:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZIXW2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 18:28:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbZIXW2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 18:28:31 -0400
Date: Thu, 24 Sep 2009 15:26:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux@rainbow-software.org
Cc: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, john stultz <johnstul@us.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, stable@kernel.org,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [Bugme-new] [Bug 14222] New: Hibernation oopses for the 2nd
 time with 2.6.31 (won't fit the screen)
Message-Id: <20090924152628.b4d2dd49.akpm@linux-foundation.org>
In-Reply-To: <bug-14222-10286@http.bugzilla.kernel.org/>
References: <bug-14222-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 14:07:09 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14222
> 
>            Summary: Hibernation oopses for the 2nd time with 2.6.31 (won't
>                     fit the screen)
>            Product: Timers
>            Version: 2.5
>     Kernel Version: 2.6.31
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: johnstul@us.ibm.com
>         ReportedBy: linux@rainbow-software.org
>         Regression: Yes

It's a 2.6.21 regression.

> 
> Hibernation worked great with 2.6.30 - I had over a month of uptime (it never 
> worked so well before - always crashed after some time). But in 2.6.31, it's 
> broken again - and completely. The first hibernation works but it always 
> crashes on the second one.
> 
> The oops won't fit the screen, even 1280x1024 is not enough.
> 
> I bisected it and found this:

Thanks for bisecting it.

> c7121843685de2bf7f3afd3ae1d6a146010bf1fc is first bad commit
> commit c7121843685de2bf7f3afd3ae1d6a146010bf1fc
> Author: Magnus Damm <magnus.damm@gmail.com>
> Date: __ Tue Jul 28 14:09:55 2009 -0700
> 
> __ __ clocksource: Save mult_orig in clocksource_disable()
> 
> __ __ To fix the common case where ->enable() does not set up
> __ __ mult, make sure mult_orig is saved in mult on disable.
> 
> __ __ Also add comments to explain why we do this.
> 
> __ __ Signed-off-by: Magnus Damm <damm@igel.co.jp>
> __ __ Cc: johnstul@us.ibm.com
> __ __ Cc: lethal@linux-sh.org
> __ __ Cc: akpm@linux-foundation.org
> __ __ LKML-Reference: <20090618152432.10136.9932.sendpatchset@rx1.opensource.se>
> __ __ Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> :040000 040000 c965062bc79af46cdb3522fc7ab1cc81d2f84de3
> 26616c88a8128b25fd15c3da39ac6251cd9723b6 M __ __ __include
> 
> Reverting this commit fixes the problem.

OK, I cc'ed everyone.

Guys, is reverting this patch the best approach?

It might be for 2.6.31.x but not for 2.6.32, perhaps?
