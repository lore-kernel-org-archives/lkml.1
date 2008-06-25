Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbYFYOL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbYFYOL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYFYOLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:11:49 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:4830 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbYFYOLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:11:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=tY9v3EoevxodBx+HbsfgkKpF+WV1XHLFdcGOhygl1VFs3nISVMpWpKk3liwZ9im6ZB
         JfLaRnoCZ5VLXlQZCbZNdx//f8jccphR52Athpiij68kOFauRy6E8yDpc05G0iJV6p2A
         FfStOpKNsYjqyLgCZq+NicjY87iq0y15fhDSs=
Message-ID: <cfd18e0f0806250711l6b723dbbs621ee51db07e0d73@mail.gmail.com>
Date: Wed, 25 Jun 2008 16:11:46 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: When did High-Resolution Timers hit mainline?
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "john stultz" <johnstul@us.ibm.com>,
       "Subrata Modak" <subrata@linux.vnet.ibm.com>,
       "Stephane Chazelas" <stephane_chazelas@yahoo.fr>
In-Reply-To: <cfd18e0f0806250633j2901aa89u5609f1b9a4a37dc6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0806232335p3e05d690o5a5cef8c9626fae7@mail.gmail.com>
	 <cfd18e0f0806242108s79ccc948n73e2ad5f694ecdaf@mail.gmail.com>
	 <e2e108260806242332i2138f7f7t63626d45a33fdce2@mail.gmail.com>
	 <cfd18e0f0806250633j2901aa89u5609f1b9a4a37dc6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the suggestions from Bart and Thomas, I've now reworked the text
as below.  Seem okay now?

Cheers,

Michael

  The Software Clock, HZ, and Jiffies
       The accuracy of various system calls that set timeouts,  (e.g.,
       select(2),   sigtimedwait(2))   and  measure  CPU  time  (e.g.,
       getrusage(2)) is limited by  the  resolution  of  the  software
       clock,  a clock maintained by the kernel which measures time in
       jiffies.  The size of a jiffy is determined by the value of the
       kernel constant HZ.

       The  value  of  HZ  varies  across kernel versions and hardware
       platforms.  On i386 the situation is as follows: on kernels  up
       to  and  including  2.4.x,  HZ was 100, giving a jiffy value of
       0.01 seconds; starting with 2.6.0, HZ was raised to 1000,  giv-
       ing  a  jiffy  of  0.001  seconds.  Since kernel 2.6.13, the HZ
       value is a kernel configuration parameter and can be  100,  250
       (the  default)  or  1000,  yielding a jiffies value of, respec-
       tively, 0.01, 0.004, or 0.001 seconds.  Since kernel 2.6.20,  a
       further  frequency  is  available:  300,  a number that divides
       evenly for the common video frame rates (PAL, 25 HZ;  NTSC,  30
       HZ).

       The  times(2)  system call is a special case.  It reports times
       with a granularity defined  by  the  kernel  constant  USER_HZ.
       Userspace applications can determine the value of this constant
       using sysconf(_SC_CLK_TCK).

   High-Resolution Timers
       Before Linux 2.6.21, the accuracy of  timer  and  sleep  system
       calls (see below) was also limited by the size of the jiffy.

       Since  Linux  2.6.21,  Linux  supports  high-resolution  timers
       (HRTs), optionally configurable via CONFIG_HIGH_RES_TIMERS.  On
       a  system  that  supports HRTs, the accuracy of sleep and timer
       system calls is no longer constrained by the jiffy, but instead
       can be as accurate as the hardware allows (microsecond accuracy
       is typical of modern  hardware).   You  can  determine  whether
       high-resolution timers are supported by checking the resolution
       returned by  a  call  to  clock_getres(3)  or  looking  at  the
       "resolution" entries in /proc/timer_list.

       HRTs are not supported on all hardware architectures.  (Support
       is provided on x86, arm, and powerpc, among others.)
   ...
   Sleeping and Setting Timers
       Various system calls and functions allow  a  program  to  sleep
       (suspend  execution)  for  a  specified  period  of  time;  see
       nanosleep(2), clock_nanosleep(2), and sleep(3).

       Various system calls allow  a  process  to  set  a  timer  that
       expires at some point in the future, and optionally at repeated
       intervals; see alarm(2), getitimer(2),  timerfd_create(2),  and
       timer_create(3).
==END==
