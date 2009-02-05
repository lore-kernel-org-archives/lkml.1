Return-Path: <linux-kernel-owner+w=401wt.eu-S1760561AbZBETJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbZBETJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759534AbZBETJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:09:17 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:48851 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbZBETJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:09:13 -0500
X-Greylist: delayed 167558 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Feb 2009 14:09:11 EST
To: ZhangRui <rui.zhang@intel.com>, yakui_zhao <yakui.zhao@intel.com>,
       Pavel Machek <pavel@ucw.cz>
Cc: "linux-acpi\@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm\@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Acer 6592 TM, suspend to ram and resume freeze
References: <873aevl0l8.fsf@free.fr> <1233712347.6643.7.camel@rzhang-desktop>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 05 Feb 2009 20:08:58 +0100
In-Reply-To: <1233712347.6643.7.camel@rzhang-desktop> (ZhangRui's message of "Wed\, 04 Feb 2009 09\:52\:27 +0800")
Message-ID: <8763jo1z1x.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ZhangRui <rui.zhang@intel.com> writes:
> what if you build in the ACPI processor driver (CONFIG_ACPI_PROCESSOR=y)
> and boot with "processor.max_cstate=1"?
That doesn't help, thanks for the hint.

>> Now, I notice that loading acpi-cpufreq triggers the following message :
>> > log: Jan 19 18:23:42 velvet kernel: ACPI: EC: non-query interrupt received, switching to interrupt mode
>> 
> I don't think these two are related. can you please make a double check?
You're right. Loading thermal.ko leads to the same message, yet the suspend to
ram works.

yakui_zhao <yakui.zhao@intel.com> writes:
> Will you please try the latest kernel(2.6.29-rc3)?
>      If the problem still exists, please attach the output of dmesg,
> acpidump.
Yes, great, it works in 2.6.29-rc3!!! It's amazing, because, when I check acpi
in [1], I see no change which could have led to the fix.
I provided acpidump in [2] as information.

Well, I' consider the topic solved. I'll make further tests this weekend to test
all of my laptop functions, but my hopes are quite high.

Thanks a lot, the three of you.

--
Robert

[1] : Git ACPI check
velvet:~/kernel_src/linux-2.6# git-log --pretty=oneline v2.6.29-rc3 ^v2.6.29-rc1 drivers/acpi/
88d998c264722cd6e8fafa42aee191f7d9194960 Merge branch 'misc' into release
f1f055f1036a20742608c28ee82139f572dfd031 Merge branches 'bugzilla-11884' and 'bugzilla-8544' into release
d08ca2ca743f324eceba59e93188f9439e966bce ACPI: rename main.c to sleep.c
0e4240d94628530a912d216cad1e32d2e3827327 thermal fixup for broken BIOS which has invalid trip points.
c6cb0e878446c79f42e7833d7bb69ed6bfbb381f ACPI: EC: Don't trust ECDT tables from ASUS
235c4a59278eb07e61d909f1f0c233733034a8b3 ACPI: EC: Limit workaround for ASUS notebooks even more

[2] http://belgarath.hd.free.fr/download/acer6592tm/acpidump.txt.gz
