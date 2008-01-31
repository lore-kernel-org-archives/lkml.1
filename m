Return-Path: <linux-kernel-owner+w=401wt.eu-S933238AbYAaVlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbYAaVlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbYAaVlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:41:09 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:23194 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbYAaVlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:41:08 -0500
Message-ID: <47A24072.4090001@msgid.tls.msk.ru>
Date: Fri, 01 Feb 2008 00:41:06 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: swsusp on an AMD x2-64, 2.6.24: regression?
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I upgraded from 2.6.23 to 2.6.24, suspend to
disk does not work anymore on this machine.  I'm
trying to debug this now, for several hours already,
without much luck so far.

The machine is based on AMD X2-64 (BE-2400) CPU and
NVidia MCP51PV (GeForce 6150/NForce 430) chipset.

Up until 2.6.23 (both 32- and 64-bit kernels), suspend/
resume worked just fine without any glitch.

With 2.6.24, it tries to suspend, saves pages to disk,
when prints this:

..Saving pages... done.
Sl
Suspending console(s)
_

At this point, nothing more happens.  It does not
react to keyboard or to any other external events,
only reset/poweroff helps.  Note the "Sl" stuff -
I guess it's a beginning of some message, but I
don't know which one.

After a hard reboot after that, the system resumes
from the saved image.

This happens with both 32- and 64-bits kernels, when
using either good'old `echo disk > /sys/power/state'
or when using s2disk from uswsusp (with 32bits kernel,
as this utility does not work with 64bits kernel when
compiled as 32bits application).  Note that when using
s2disk with 2.6.24, very similar picture is shown -
that same "Sl" line.

The only noticeable changes in my config (x86-64 one)
compared with the one from 2.6.23 is - I enabled tickless
(dyntics) and high-res timers, CPU_IDLE and FAIR_CGROUP_SCHED.
I recompiled the kernel without those options (on by one), --
the effect on suspend is exactly the same.

Is there anything I can do to further diagnose this?

Thanks!

/mjt

