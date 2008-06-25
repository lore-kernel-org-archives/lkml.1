Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbYFYEJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbYFYEJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbYFYEIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:08:55 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:60776 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbYFYEIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Sb4ECTMIUiOEiAwgrw30F+kjztvfD8wDAxx9p4fRxJ4anhaAFEG3nLuew7VhJxczpO
         Ro4OD7vWv/ZuBNKjORe0k3/1gnIOp7MoDs3ITsI6tOT2XFGXiQNI092j8SAoBieT0qGA
         UPsdjWoAPH8c9F7uiMj5ZOyd0dnLycAmXVliI=
Message-ID: <cfd18e0f0806242108s79ccc948n73e2ad5f694ecdaf@mail.gmail.com>
Date: Wed, 25 Jun 2008 06:08:53 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: When did High-Resolution Timers hit mainline?
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "john stultz" <johnstul@us.ibm.com>
In-Reply-To: <cfd18e0f0806232335p3e05d690o5a5cef8c9626fae7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0806232335p3e05d690o5a5cef8c9626fae7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 8:35 AM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> Hi Ingo, Thomas,
>
> I want to update some timer and sleep man pages to reflect the arrival
> of high-resolution timers.  However, it's not quite clear to me when
> HRTs properly arrived in mainline.  Was it 2.6.21?  And at that point,
> was the resolution for all timer and sleep calls based on HRTs, so
> that they all became more accurate?  (Or was it the case that various
> system calls switched over to HRTs in different later kernel
> versions?)  Specifically, I'm thinking of the following system calls
>
> nanosleep()
> clock_nanosleep()
> setitimer()
> timer_create()/timer_settime()
>
> Was it the case that pre 2.6.21 (or whatever) these were all
> jiffy-based in their accuracy, and then post 2.6.21, they were all HRT
> based (if CONFIG_HIGH_RES_TIMERS is enabled)?

So I got confused by the fact that CONFIG_HIGH_RES_TIMERS only
appeared in 2.6.21.  I plan to include the following text to time(7)
for the next man-pages release.  Does it look okay?

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

   High-Resolution Timers
       Before  Linux  2.6.16,  the  accuracy of timer and sleep system
       calls (see below) was also limited by the size of the jiffy.

       Since  Linux  2.6.16,  Linux  supports  high-resolution  timers
       (HRTs),  optionally  configurable  since kernel 2.6.21 via CON-
       FIG_HIGH_RES_TIMERS.  On a system that supports HRTs, the accu-
       racy  of  sleep and timer system calls is no longer constrained
       by the jiffy, but instead can be as accurate  as  the  hardware
       allows (microsecond accuracy is typical of modern hardware).

       HRTs are not supported on all hardware architectures.  (Support
       is provided on x86, arm, and powerpc, among others.)
