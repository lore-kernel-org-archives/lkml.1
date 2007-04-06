Return-Path: <linux-kernel-owner+w=401wt.eu-S1751727AbXDFUXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbXDFUXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXDFUXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:23:42 -0400
Received: from 64-191-130-94.service.qx.net ([64.191.130.94]:41421 "EHLO
	panacea.theblackmoor.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751727AbXDFUXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:23:40 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Apr 2007 16:23:40 EDT
Message-ID: <11584.192.146.101.26.1175890435.squirrel@panacea.theblackmoor.net>
Date: Fri, 6 Apr 2007 16:13:55 -0400 (EDT)
Subject: PROBLEM:  ACPI Thermal Zone for CPU0 does not update after 
     hibernation
From: "Walter Francis" <wally@theblackmoor.net>
To: linux-kernel@vger.kernel.org
Cc: wally@theblackmoor.net
Reply-To: wally@theblackmoor.net
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After hibernating, the CPU0 thermal zone never updates.  It will stay at 59C
forever for example.

I've tried making the thermal driver a module and unloading it before
hibernating and it didn't help, also went back as far as 2.6.19 and saw the
same behavior there.  Currently using 2.6.21-pre6.  If I reboot or suspend to
*RAM*, the problem fixes itself.  And CPU1's thermal zone is fine.  But CPU0
if it's (example) 59C, it stays 59C forever.  I'm seeing it in gkrellm, but
it's coming from /proc/acpi/thermal_zone/*/temperature and verified to match
there.

I'm using Fedora Core 6 on a Lenovo 3000 V100 laptop, custom kernel.  Still
modular, but stripped down to eliminate things that are not part of this
particular laptop.  All features work, suspend to ram and disk work fine,
sound, wireless, etc.  Just this quirk with the ACPI thermal zone crops up
when hibernating to disk.

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T5500  @ 1.66GHz
stepping        : 6
cpu MHz         : 1000.000
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat p
se36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni
monitor d
s_cpl est tm2 ssse3 cx16 xtpr lahf_lm
bogomips        : 3328.18
clflush size    : 64

Repeat for CPU 1.  Core 2 Duo T5500.  Kernel is SMP, both CPUs show, just not
pasting both for brevity.

I have turned ACPI debug on, here's copies of dmesg before hibernating:
http://unlimitedphoto.com/~wally/stuff/dmesg-2.6.21-pre6

And after hibernating:
http://unlimitedphoto.com/~wally/stuff/dmesg-2.6.21-pre6-afterhibernation

Please keep me on the CC so I can respond to queries, as I am not on the
mailing list.

-- 
Walter Francis

khayts.us
theblackmoor.net
unlimitedphoto.com

