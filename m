Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbYFWICy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbYFWICy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYFWICG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:02:06 -0400
Received: from mail.jambit.com ([62.245.207.83]:55855 "EHLO mail.jambit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbYFWICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:02:03 -0400
Message-ID: <485E00CD.9060503@gmail.com>
Date: Sun, 22 Jun 2008 09:35:41 +0200
From: Michael Kerrisk <mtk.manpages@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Roman Zippel <zippel@linux-m68k.org>
Subject: nanosleep() uses CLOCK_MONOTONIC, should be CLOCK_REALTIME?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

(I gues you are the right target for this?)

The POSIX.1 specification of nanosleep() says:

        But, except for the case of being interrupted by a signal, the
        suspension time shall not be less than the time  specified  by
        rqtp, as measured by the system clock CLOCK_REALTIME.


However, reading kernel/hrtimer.c:sys_nanosleep(), it appears that
CLOCK_MONOTONIC is used.

     return hrtimer_nanosleep(&tu, rmtp, HRTIMER_MODE_REL, CLOCK_MONOTONIC);

Is there a reason to use CLOCK_MONOTONIC, instead of CLOCK_REALTIME?  Is it
intentional?  If yes, then I should document this in the man-pages.  If not,
then it should be fixed.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages onlne: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html

