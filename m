Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbYKZKvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbYKZKvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 05:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYKZKv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 05:51:29 -0500
Received: from mercuryimc.plus.com ([80.229.200.144]:45382 "EHLO
	mimc.mimc.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751113AbYKZKv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 05:51:27 -0500
Message-ID: <492D2A2A.905@mimc.co.uk>
Date: Wed, 26 Nov 2008 10:51:22 +0000
From: Mark Jackson <mpfj@mimc.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, mrustad@gmail.com
Subject: Re: Help using initramfs
References: <492C6238.7060507@mimc.co.uk> <492C676A.6020901@zytor.com>
In-Reply-To: <492C676A.6020901@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mark Jackson wrote:
>> I'm not sure if this is the correct place to be asking, but I've spend a
>> while searching Google and am still no wiser.
>>
>> I'm looking to use initramfs to create a simple bootable linux distro
>> for our AVR32 based boards.
>>
>> However, I have hit a brick wall at nearly the first step.
>>
>> So far I've managed to create a "bloated" kernel containing the
>> initramfs directory structure and I'm just trying to get a simple "Hello
>> World" test app running.
>>
>> The kernel boots, and the app runs, but I get no output on the console.
>>
> 
> Make sure /dev/null, /dev/zero, and *especially* /dev/console exists in
> your initramfs.

Aha ... after much head scratching, I now understand my error.

As you suggested, I hadn't correctly made my /dev entries.

Thanks.

My next problem is this ... below is a copy of my /init script ...

#!/bin/sh
#Mount things needed by this script
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mdev -s
echo "wibble"
echo "qwerty" > /dev/console
exec /sbin/init
exit 0

And this is the console output ...

mount: permission denied. (are you root?)
mount: permission denied. (are you root?)
mdev: /sys/block: No such file or directory
mdev: /sys/class: No such file or directory
wibble
qwerty
Mounting virtual filesystems:
mount: permission denied. (are you root?)
   mount /proc failed
mount: permission denied. (are you root?)
   mount /sys failed
mount: permission denied. (are you root?)
   mount /dev failed
mount: permission denied. (are you root?)
   mount /config failed
mount: permission denied. (are you root?)
   mount /tmp failed
mount: permission denied. (are you root?)
   mount /var/run failed
mount: permission denied. (are you root?)
   mount /var/log failed
   WARNING: not able to mount all virtual file systems
Setting up mdev: eth0: link up (100/Full)
/etc/init.d/S01hotplug: line 11: can't create /proc/sys/kernel/hotplug: 
nonexistent directory
failed
Setting hostname: hostname: permission denied. (are you root?)
failed
Starting syslogd: done
Log messages to syslog: /etc/init.d/S08syslog: line 24: can't create 
/proc/sys/kernel/printk: nonexistent directory
failed
Starting klogd: done
Probing modules:
Mounting local filesystems: mount: mounting /dev/mmcblk0 on 
/media/sdcard failed: No such file or directory
failed
Network interfaces: ifconfig: SIOCSIFADDR: Permission denied
ifconfig: SIOCSIFFLAGS: Permission denied
failed
/etc/init.d/S50lighttpd: line 4: /usr/sbin/lighttpd: not found
can't open /dev/ttyS1: No such file or director
can't open /dev/ttyS1: No such file or director
can't open /dev/ttyS1: No such file or director

Does /init not inherently run as root ?

If not, how do I fix the problem ?

Mark
