Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbZCKMI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbZCKMI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZCKMIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:08:17 -0400
Received: from hobbit.corpit.ru ([81.13.33.150]:21587 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040AbZCKMIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:08:16 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2009 08:08:16 EDT
Message-ID: <49B7A79A.6090008@msgid.tls.msk.ru>
Date: Wed, 11 Mar 2009 14:59:22 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Mika Tiainen <mikat@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Slow clock on AMD 740G chipset
References: <874ozu2hcl.fsf@divinity.mikat.iki.fi> <20090310101807.GD20716@alberich.amd.com> <20090311100525.GE20716@alberich.amd.com>
In-Reply-To: <20090311100525.GE20716@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> On Tue, Mar 10, 2009 at 11:18:07AM +0100, Andreas Herrmann wrote:
>> On Tue, Jan 20, 2009 at 04:16:10PM +0200, Mika Tiainen wrote:
>>> Hi,
>>>
>>> I built a new machine with Gigabyte GA-MA74GM-S2H motherboard that ntpd
>>> can't keep synced. Could this be a kernel bug or is it a hardware
>>> problem?
>>>
>>> Installed with Debian 2.6.27 kernel and currently running a self built
>>> 2.6.28.1, both have the problem. It's falling behind over 2s/15min:
>>>
>>> Jan 19 22:08:23 aeon ntpd[31468]: time reset +2.226349 s
>>> Jan 19 22:24:11 aeon ntpd[31468]: time reset +2.185085 s
>>> Jan 19 22:40:08 aeon ntpd[31468]: time reset +2.308958 s
>>> Jan 19 22:56:23 aeon ntpd[31468]: time reset +2.253836 s
>>> Jan 19 23:13:03 aeon ntpd[31468]: time reset +2.291917 s
>>> Jan 19 23:28:14 aeon ntpd[31468]: time reset +2.091014 s
>>> Jan 19 23:43:47 aeon ntpd[31468]: time reset +2.209660 s
>>> Jan 19 23:59:09 aeon ntpd[31468]: time reset +2.150145 s
>>> Jan 20 00:15:44 aeon ntpd[31468]: time reset +2.256261 s
>>> Jan 20 00:31:47 aeon ntpd[31468]: time reset +2.253873 s
>>>
>>> I have tried different clocksources. The machine defaults to hpet,
>>> acpi_pm makes no difference and

Same here, also on 740G, but on other 2 machines with 780G
it also happens.

>> That's annoying but I can't really help you with this. Maybe using
>> adjtimex as described in section 9.1.6 in
>> http://support.ntp.org/bin/view/Support/KnownHardwareIssues is an
>> option for you.

And adjtimex helped me on all 3 machines.
Running it in self-calibrate mode (that 70 sec thing)
plus running ntpd was enough for me for now.

What's interesting is that some time ago it worked just fine,
and, which is even more interesting, windows on this very
hardware shows quite good time stability (WITHOUT setting
the time using [s]ntp, its ntp client is disabled).

[]
> So it's "mere a question" of calibration on your system. AFAIK
> you have to increase the tick value to not fall behind ntp-time, e.g.
> increasing tick value from 10000 to 10025

Well, sorta.  Given the amount of hardware that exposes this
behavour, AND the fact that it worked fine with previous
kernels (I think it was ok with 2.6.26), AND that windows
works just fine, it's not "calibration of your system"
question anymore.  It's now kernel bug question... ;)

BTW, the same Gigabyte GA-MA74GM-S2H mobo is here.
Other motherboards that exposes the same issue here:

   M3A78-EM (Asus, AMD780G)
   M3A-H/HDMI (Asus, AMD780G)

It never happened (so far) on M2N-SLI DELUXE (also Asus,
nVidia MCP55) and on M2N-VM DVI (nVidia MCP67).

/mjt
