Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbYJIVhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbYJIVhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755895AbYJIVhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:37:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:42799 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbYJIVhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:37:03 -0400
Message-ID: <ac3eb2510810091437s79a105a4u26953201d556f0d0@mail.gmail.com>
Date: Thu, 9 Oct 2008 23:37:01 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Arkadiusz Miskiewicz" <a.miskiewicz@gmail.com>
Subject: Re: loading ipmi_watchdog causes tons of other watchdog modules to be loaded
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200810092218.29000.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <200810091348.19828.a.miskiewicz@gmail.com>
	 <200810092102.16110.a.miskiewicz@gmail.com>
	 <ac3eb2510810091209rd76c8a4j83a6a48d5db5d4f9@mail.gmail.com>
	 <200810092218.29000.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m99LbMdq021315

On Thu, Oct 9, 2008 at 10:18 PM, Arkadiusz Miskiewicz<a.miskiewicz@gmail.com> wrote:> On Thursday 09 of October 2008, Kay Sievers wrote:>> On Thu, Oct 9, 2008 at 9:02 PM, Arkadiusz Miskiewicz>>>> <a.miskiewicz@gmail.com> wrote:>> > On Thursday 09 October 2008, Kay Sievers wrote:>> >> On Thu, Oct 9, 2008 at 7:22 PM, Arkadiusz Miskiewicz>> >>>> >> > ... but that ipmi_watchdog is the correct driver that handles>> >> > /dev/watchdog, so this shouldn't be happening, correct?>> >>>> >> While the driver you expect to work is loaded, what does:>> >>   ls -l /dev/watchdog>> >> print?>> >>>> >> If the devno of this node is 10:130, what does:>> >>   find /sys/class /sys/devices/ -name dev | xargs grep 10:130>> >> print?>> >>> > # ls -l /dev/watchdog>> > crw------- 1 root root 10, 130 sie  8 17:00 /dev/watchdog>> > # find /sys/class /sys/devices/ -name dev | xargs grep 10:130>> > /sys/class/misc/watchdog/dev:10:130>>>> Ok, so you actually have a driver bound to that device number, and it>> should not trigger the usual module autoloading mechanism.>>>> What does:>>   ls -l /sys/class/misc/watchdog/>> # ls -l /sys/class/misc/watchdog/> razem 0> -r--r--r-- 1 root root 4096 paÅº  9 22:02 dev> drwxr-xr-x 2 root root    0 paÅº  9 22:02 power> lrwxrwxrwx 1 root root    0 paÅº  9 22:22 subsystem -> ../../misc> -rw-r--r-- 1 root root 4096 paÅº  9 22:02 uevent>>>> and>>   ls -l /sys/class/misc/watchdog/device/>> print?>> # LC_ALL=C ls -l /sys/class/misc/watchdog/device/> ls: cannot access /sys/class/misc/watchdog/device/: No such file or directory>>>> Does the /sys/class/misc/watchdog/ directory exist, before you load>> the module you expect to be the driver behind /dev/watchdog?>> It doesn't exist before. modprobe ipmi_watchdog,> then /sys/class/misc/watchdog/ becomes available.>>> To clarify, the other modules get loaded, after you loaded but module,>> the above /sys/class/misc/watchdog/ directory exists, and only if you>> read from the device, all the other modules get loaded?>> Exactly.  I load ipmi_watchdog, /sys/class/misc/watchdog/ becomes available> (no /sys/class/misc/watchdog/device/ though), then cat /dev/watchdog and this> causes that other watchdog modules are loaded.
Hmm, sounds strange.
Can you create an executable shell script "/mp" like:  #!/bin/sh  echo $3 >> /mp.log
point /proc/sys/kernel/modprobe to it:  echo /mp > /proc/sys/kernel/modprobe
and open the device node. The /mp.log file shows us the alias thekernel is requesting?
Kayÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
