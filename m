Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbZHMWHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbZHMWHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 18:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbZHMWHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 18:07:37 -0400
Received: from smtp-2.sys.kth.se ([130.237.32.160]:60523 "EHLO
	smtp-2.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZHMWHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 18:07:36 -0400
X-Greylist: delayed 1774 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Aug 2009 18:07:35 EDT
Message-ID: <4A8487AA.1070002@kth.se>
Date: Thu, 13 Aug 2009 23:37:46 +0200
From: Arvid Brodin <arvidb@kth.se>
User-Agent: Thunderbird 2.0.0.22 (X11/20090705)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: kernel freezes, possibly via velocity-related
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since I started running deluged (a bittorrent daemon) on my file server,
I've started getting sporadic kernel freezes, a few times a week or so.

Symptoms:
* Keyboard stops responding (SysRq combos does not work),
* No panic/oops message on the console; the screen displays the normal
login prompt with a blinking cursor,
* The network activity LED flashes steadily at 1-2 Hz. The corresponding
LED on my switch blinks too, but the traffic does not seem to get
forwarded to any other port on the switch (no other lights blinking),
* The machine does not respond to pings or ssh logins,
* Nothing in var/log/messages or kern.log that I can relate to the
freeze (I have gotten some "UDP: short packet" and "eth0: excessive work
at interrupt" messages a few hours before the freezes a few times, but
that's all).

I've never gotten a freeze with the deluge daemon stopped (which it has
been for many weeks sometimes), but consistently get freezes, often
within a day or two, when it is started and have active torrents.

In addition to the kernel I currently run (2.6.29.4), the freezes also
occured with gentoo kernels 2.6.23-gentoo-r8 and 2.6.27-gentoo-r10.

# uname -a
Linux sv1 2.6.29.4 #1 Thu May 21 03:26:33 CEST 2009 i686 VIA Esther
processor 1200MHz CentaurHauls GNU/Linux

# lspci -vvv
See http://pastebin.com/f21145883

# cat /proc/cpuinfo
processor	: 0
vendor_id	: CentaurHauls
cpu family	: 6
model		: 10
model name	: VIA Esther processor 1200MHz
stepping	: 9
cpu MHz		: 1199.496
cache size	: 128 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce apic sep mtrr pge cmov pat
clflush acpi mmx fxsr sse sse2 tm nx pni est tm2 rng rng_en ace ace_en
ace2 ace2_en phe phe_en pmm pmm_en
bogomips	: 2399.95
clflush size	: 64
power management:


Should I report this to the maintainer of my network driver? I'm not
sure the symptoms are clear enough to directly blame the network driver,
but I do suspect it. Is there some way I can debug a frozen kernel to
zoom in on the problem?

-- 
Arvid
