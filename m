Return-Path: <linux-kernel-owner+w=401wt.eu-S1759174AbXF2KCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbXF2KCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 06:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXF2KBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 06:01:54 -0400
Received: from www.osadl.org ([213.239.205.134]:45697 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751689AbXF2KBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 06:01:54 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: "Midhun Agnihotram" <agnimidhun@gmail.com>
Subject: Re: Fwd: Mounting MMC card
Date: Fri, 29 Jun 2007 12:01:51 +0200
User-Agent: KMail/1.9.5
Cc: "Pierre Ossman" <drzeus-mmc@drzeus.cx>, jdi@l4x.org,
       linux-kernel@vger.kernel.org
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com> <4684D358.9090402@drzeus.cx> <4dde4acb0706290245t5810b9ebrbb682ecb72f21830@mail.gmail.com>
In-Reply-To: <4dde4acb0706290245t5810b9ebrbb682ecb72f21830@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706291201.51387.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 29 Juni 2007 11:45 schrieb Midhun Agnihotram:
> >
> > This all looks correct. How about /proc/partitions? And what's in /sys/block?
> >
> 
> Both of them show no sign of MMC.
> 
> / # cat /proc/partitions
> major minor  #blocks  name
> 
>   31     0       8192 mtdblock0
>   31     1        384 mtdblock1
>   31     2       1664 mtdblock2
>   31     3       2048 mtdblock3
>   31     4       4096 mtdblock4
> 
> 
> 
> / # cd /sys/block/
> /sys/block # ls -l
> drwxr-xr-x    3 0        0               0 Jan  1 00:00 mtdblock0
> drwxr-xr-x    3 0        0               0 Jan  1 00:00 mtdblock1
> drwxr-xr-x    3 0        0               0 Jan  1 00:00 mtdblock2
> drwxr-xr-x    3 0        0               0 Jan  1 00:00 mtdblock3
> drwxr-xr-x    3 0        0               0 Jan  1 00:00 mtdblock4
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram0
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram1
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram10
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram11
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram12
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram13
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram14
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram15
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram2
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram3
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram4
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram5
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram6
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram7
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram8
> drwxr-xr-x    2 0        0               0 Jan  1 00:00 ram9

For comparison, here's what it looks like here (kernel 2.6.21.5, udev):

# cat /proc/partitions
major minor  #blocks  name

  31     0        512 mtdblock0
  31     1       4096 mtdblock1
  31     2      28160 mtdblock2
 254     0     250880 mmcblk0
 254     1     250697 mmcblk0p1
# ls -l /sys/block/
drwxr-xr-x    6 root     root            0 Jun 29 08:41 mmcblk0
drwxr-xr-x    5 root     root            0 Jun 29 08:41 mtdblock0
drwxr-xr-x    5 root     root            0 Jun 29 08:41 mtdblock1
drwxr-xr-x    5 root     root            0 Jun 29 08:41 mtdblock2
# ls -l /sys/block/mmcblk0
-r--r--r--    1 root     root         4096 Jun 29 08:41 dev
lrwxrwxrwx    1 root     root            0 Jun 29 10:07 device -> ../../class/mmc_host/mmc0/mmc0:0002
drwxr-xr-x    2 root     root            0 Jan  1  1970 holders
drwxr-xr-x    3 root     root            0 Jun 29 08:41 mmcblk0p1
drwxr-xr-x    3 root     root            0 Jan  1  1970 queue
-r--r--r--    1 root     root         4096 Jun 29 08:41 range
-r--r--r--    1 root     root         4096 Jun 29 08:41 removable
-r--r--r--    1 root     root         4096 Jun 29 08:41 size
drwxr-xr-x    2 root     root            0 Jan  1  1970 slaves
-r--r--r--    1 root     root         4096 Jun 29 08:41 stat
lrwxrwxrwx    1 root     root            0 Jun 29 08:41 subsystem -> ../../block
--w-------    1 root     root         4096 Jun 29 08:41 uevent
# ls -l mmcblk0p1
ls: mmcblk0p1: No such file or directory
# ls -l /sys/block/mmcblk0/mmcblk0p1
-r--r--r--    1 root     root         4096 Jun 29 10:08 dev
drwxr-xr-x    2 root     root            0 Jan  1  1970 holders
-r--r--r--    1 root     root         4096 Jun 29 10:08 size
-r--r--r--    1 root     root         4096 Jun 29 10:08 start
-r--r--r--    1 root     root         4096 Jun 29 10:08 stat
lrwxrwxrwx    1 root     root            0 Jun 29 10:08 subsystem -> ../../../block
--w-------    1 root     root         4096 Jun 29 08:41 uevent
# cat /sys/block/mmcblk0/mmcblk0p1/size
501394
#

Hans



