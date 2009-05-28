Return-Path: <linux-kernel-owner+w=401wt.eu-S1764353AbZE1UeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764353AbZE1UeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757899AbZE1Ud5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:33:57 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49516 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbZE1Ud5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:33:57 -0400
Subject: Re: [tip:timers/ntp] ntp: adjust SHIFT_PLL to improve NTP
 convergence
From: John Stultz <johnstul@us.ibm.com>
To: mingo@redhat.com, hpa@zytor.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org, Miroslav Lichvar <mlichvar@redhat.com>
In-Reply-To: <tip-22cfbbfd9f67b67fe073010f51cb71d3632387d5@git.kernel.org>
References: <200905051956.n45JuVo9025575@imap1.linux-foundation.org>
	 <tip-22cfbbfd9f67b67fe073010f51cb71d3632387d5@git.kernel.org>
Content-Type: text/plain
Date: Thu, 28 May 2009 13:33:37 -0700
Message-Id: <1243542817.29511.523.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-06 at 09:46 +0000, tip-bot for john stultz wrote:
> Commit-ID:  22cfbbfd9f67b67fe073010f51cb71d3632387d5
> Gitweb:     http://git.kernel.org/tip/22cfbbfd9f67b67fe073010f51cb71d3632387d5
> Author:     john stultz <johnstul@us.ibm.com>
> AuthorDate: Wed, 6 May 2009 11:43:57 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 6 May 2009 11:44:02 +0200
> 
> ntp: adjust SHIFT_PLL to improve NTP convergence
> 
> The conversion to the ntpv4 reference model
> f19923937321244e7dc334767eb4b67e0e3d5c74 ("ntp: convert to the NTP4
> reference model") in 2.6.19 added nanosecond resolution the adjtimex
> interface, but also changed the "stiffness" of the frequency adjustments,
> causing NTP convergence time to greatly increase.
> 
> SHIFT_PLL, which reduces the stiffness of the freq adjustments, was
> designed to be inversely linked to HZ, and the reference value of 4 was
> designed for Unix systems using HZ=100.  However Linux's clock steering
> code mostly independent of HZ.
> 
> So this patch reduces the SHIFT_PLL value from 4 to 2, which causes NTPd
> behavior to match kernels prior to 2.6.19, greatly reducing convergence
> times, and improving close synchronization through environmental thermal
> changes.
> 
> The patch also changes some l's to L's in nearby code to avoid misreading
> 50l as 501.
> 
> [ Impact: tweak NTP algorithm for faster convergence ]

Hey Ingo,
	So I've been speaking with Miroslav (cc'ed) who maintains the RH ntpd
packages, and he's concerned that this patch takes us out of NTP's
expected behavior, which may cause problems when dealing with non-linux
systems using NTP.

We're both still trying to pin down exactly what NTP's expected behavior
should be with respect to convergence time, and there may be fixes to
the ntpd userland component that may resolve the slow convergence times
users are experiencing that the SHIFT_PLL change was trying to fix.

So in the interest of keeping the kernel's adjtimex() interface behavior
stable, I'd like to put a hold on this patch until Miroslav and I have
come to agreement about how to best resolve the issue.

So again, please don't push this when 2.6.31 opens.

thanks
-john


