Return-Path: <linux-kernel-owner+w=401wt.eu-S933297AbXEEUd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297AbXEEUd2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933330AbXEEUd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:33:27 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:36011 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933297AbXEEUd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:33:26 -0400
Date: Sat, 5 May 2007 22:30:53 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
cc: Wander Winkelhorst <w.winkelhorst@gmail.com>,
       David Johnson <dj@david-web.co.uk>, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <463CE1FB.4050305@interia.pl>
Message-ID: <Pine.LNX.4.61.0705052224360.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> 
 <200705042320.41278.dj@david-web.co.uk>  <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>
  <463C18C4.7030304@interia.pl> <5699f8f00705050144s5c00a455s8f7dba9258d83986@mail.gmail.com>
 <463CC380.3060603@interia.pl> <Pine.LNX.4.61.0705052028560.18504@yvahk01.tjqt.qr>
 <463CE1FB.4050305@interia.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 5 2007 21:58, Rafał Bilski wrote:
>
>>> I found one line which wasn't were it should be. Probably this will not 
>>> fix Your problem with powersave governor, but it is a bit related. 
>>> Looks like Longhaul isn't skipping frequency transtition when it is asked 
>>> to set f which is already set. Now after first transition it will not 
>>> try to set same frequency again. Second part contains some magic 
>>> because I don't have CN400 datasheet. It is NDA protected :-( Should 
>>> print You one byte in hex and will try to set one register. I don't 
>>> know if anything will change but it is worth testing.
>> 
>> Did not help unfortunately. The output the printk line generated was
>>   longhaul: 0x0
>> 
>> (Strangely enough, %#02x with glibc outputs "00", not "0x0".
>> And I would have expected "0x00". Subtleties of the kernel 
>> printk/glibc?)
>
>:-/ Weird. Nothing new in datasheet. Longhaul MSR seems to be OK too. 
>Would be good to check if PLL really can go downto x4,0. Can You 
>limit minimal CPU multiplier to 5,0 and check if is stable? If it 
>is check 4,5.

How do I do that? I tried `cpufreq-set -d 665 -u 665` (x5.0), but that
changed the frequency to 532 (x4.0).

I can set the CPU frequency in the BIOS, from x3.0 to x16.0, in x0.5
steps (base frequency is 133, DIMM freq is 266).

[ Actually, the values are a bit off,

cn:~ # cpufreq-info 
cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
Report errors and bugs to http://bugs.opensuse.org, please.
analyzing CPU 0:
  driver: longhaul
  CPUs which need to switch frequency at the same time: 0
  hardware limits: 532 MHz - 731 MHz
  available frequency steps: 532 MHz, 598 MHz, 731 MHz, 665 MHz
  available cpufreq governors: performance
  current policy: frequency should be within 532 MHz and 731 MHz.
                  The governor "performance" may decide which speed to use
                  within this range.
  current CPU frequency is 731 MHz (asserted by call to hardware).

]

The BIOS default is x5.5, producing 733 MHz. With longhaul/cpufreq,
I can then choose from between 533 MHz (x4.0) and the value that was
set in the BIOS.



>Please send me below part of Your dmesg too:
>CPU: After generic identify, caps: 0381b83f 00000000 00000000 00000000 00000000 00000000 00000000
>CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
>CPU: L2 Cache: 64K (32 bytes/line)
>CPU: After all inits, caps: 0381b93f 00000000 00000000 00000000 00000000 000000dd 00000000

CPU: After generic identify, caps:
0381b03f 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
CPU: L2 Cache: 64K (32 bytes/line)
CPU: After all inits, caps: 0381b13f 00000000 00000000 00000000 00000000
000000dd 00000000



Jan
-- 
