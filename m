Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYAJXuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYAJXuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:50:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbYAJXur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:50:47 -0500
Received: from simmts7-qfe0.srvr.bell.ca ([206.47.199.165]:48267 "EHLO
	simmts7-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754390AbYAJXuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:50:46 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAKw+hkecIpyl/2dsb2JhbAAIkWiYAw
Message-ID: <4786AF4C.6050509@gmail.com>
Date: Thu, 10 Jan 2008 19:50:36 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hwclock failure in x86.git
References: <4786AA11.5010805@gmail.com> <4786AB1B.4030004@zytor.com>
In-Reply-To: <4786AB1B.4030004@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Kevin Winchester wrote:
>> My first time building and booting the mm branch of x86.git was pretty
>> successful.  The only error I noticed was the following in my dmesg:
>>
>>  hwclock[622] general protection ip:804b226 sp:bff43e30 error:0
>>
>> I'm not sure exactly how to debug this.  I could bisect, but there seems
>> to be some useful debug information in there, so there might be
>> something better to try first.
>>
> 
> That's a userspace IP; it implies the userspace hwclock binary did 
> something bad, or the kernel didn't permit it to do something it should 
> have.  The best thing to do would probably to strace hwclock and see 
> what it did when it died.
> 

Unfortunately, but the time I can get a chance to run hwclock, the
problem seems to have fixed itself.  I tried booting into single user
mode, but `/etc/init.d/hwclock.sh restart` succeeds once I have my prompt.

A few other facts:

- This is an Athlon64 box running X83_32
- I use hpet=force for the Via chipset
- A little more of the demsg is:

[   17.511262] rtc_cmos 00:05: setting system clock to 2008-01-10
23:44:16 UTC (1200008656)
[   17.545948] EXT3-fs: mounted filesystem with ordered data mode.
[   17.545986] VFS: Mounted root (ext3 filesystem) readonly.
[   17.546142] Freeing unused kernel memory: 144k freed
[   17.546260] kjournald starting.  Commit interval 5 seconds
[   21.861249] hwclock[622] general protection ip:804b226 sp:bfd98480
error:0
[   22.416442] Velocity is AUTO mode
[   23.093416] Adding 1502036k swap on /dev/sda5.  Priority:-1 extents:1
across:1502036k
[   23.416756] EXT3 FS on sda1, internal journal
[   24.009669] kjournald starting.  Commit interval 5 seconds
[   24.009889] EXT3 FS on sda6, internal journal
[   24.009899] EXT3-fs: mounted filesystem with ordered data mode.
[   24.053164] eth0: Link auto-negotiation speed 100M bps full duplex
[   28.733360] agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
[   28.733872] agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
[   28.734354] agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
[   29.089412] [drm] Setting GART location based on new memory map
[   29.089842] [drm] Loading R200 Microcode
[   29.090172] [drm] writeback test succeeded in 1 usecs
[  143.076821] Marking TSC unstable due to: cpufreq changes.
[  143.084910] Time: hpet clocksource has been installed.
[  143.670905] Clocksource tsc unstable (delta = -231086796 ns)

So the TSC is being marked unstable because of cpufreq changes. I have
no idea when it comes to TSCs and HPETs and how the RTC works (other
than what the abbreviations stand for), so this all may be meaningless.
 I'll try disabling cpufreq to see if that has an effect.

-- 
Kevin Winchester

