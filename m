Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbXIIXDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbXIIXDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 19:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXIIXDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 19:03:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:31923 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbXIIXDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 19:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=rV4/zsgD2/4y9IzpoJGen7nC8DppsDeghySFiXOty4C0vaM/NYuU7x7Dx3Df0vL/rWu/TP92Fk9ysXVnpL6cUBc06NmLBim9bo3UljE4peIt2bWY/+1ulSDdzKFBMpmfj/iykcS0c1WxWhsyGDYhOtpkP1BIkP1IAdgCUORPriw=
Message-ID: <3ae72650709091603o57c976d1q8a1b5492ef041186@mail.gmail.com>
Date: Mon, 10 Sep 2007 01:03:33 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Anssi Hannula" <anssi.hannula@gmail.com>
Subject: Re: sysfs change of input/event devices in 2.6.23rc breaks udev
Cc: "Dmitry Torokhov" <dtor@insightbb.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <46E2D712.1010402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46E2D712.1010402@gmail.com>
X-Google-Sender-Auth: 2149132091cf6fe5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/8/07, Anssi Hannula <anssi.hannula@gmail.com> wrote:
> There seem to be changes in sysfs input structure between 2.6.22 and
> 2.6.23-rc5 which cause some breakage.
>
> With 2.6.22:
>
> > # LC_ALL=C ls -l /sys/class/input/input4
> > total 0
> > drwxr-xr-x 2 root root    0 Sep  8 12:51 capabilities/
> > lrwxrwxrwx 1 root root    0 Sep  8 19:48 device -> ../../../devices/platform/pcspkr/
> > drwxr-xr-x 2 root root    0 Sep  8 12:51 event4/
> > drwxr-xr-x 2 root root    0 Sep  8 12:51 id/
> > -r--r--r-- 1 root root 4096 Sep  8 19:48 modalias
> > -r--r--r-- 1 root root 4096 Sep  8 19:48 name
> > -r--r--r-- 1 root root 4096 Sep  8 19:48 phys
> > lrwxrwxrwx 1 root root    0 Sep  8 19:48 subsystem -> ../../../class/input/
> > --w------- 1 root root 4096 Sep  8 19:48 uevent
> > -r--r--r-- 1 root root 4096 Sep  8 19:48 uniq
>
> > # ls -l /sys/class/input/event4
> > lrwxrwxrwx 1 root root 0 Sep  8 19:48 /sys/class/input/event4 -> ../../class/input/input4/event4/
> > # ls -l /sys/class/input/event4/
> > total 0
> > -r--r--r-- 1 root root 4096 Sep  8 19:58 dev
> > lrwxrwxrwx 1 root root    0 Sep  8 19:58 device -> ../../../../devices/platform/pcspkr/
> > lrwxrwxrwx 1 root root    0 Sep  8 19:58 subsystem -> ../../../../class/input/
> > --w------- 1 root root 4096 Sep  8 19:58 uevent
>
> With 2.6.23-rc5:
>
> > # ls -l /sys/class/input/input5
> > total 0
> > drwxr-xr-x 2 root root    0 Sep  8 19:47 capabilities/
> > lrwxrwxrwx 1 root root    0 Sep  8 19:03 device -> ../../../devices/platform/pcspkr/
> > drwxr-xr-x 2 root root    0 Sep  8 19:47 id/
> > lrwxrwxrwx 1 root root    0 Sep  8 19:47 input:event5 -> ../../../class/input/event5/
> > -r--r--r-- 1 root root 4096 Sep  8 19:03 modalias
> > -r--r--r-- 1 root root 4096 Sep  8 19:03 name
> > -r--r--r-- 1 root root 4096 Sep  8 19:47 phys
> > drwxr-xr-x 2 root root    0 Sep  8 19:47 power/
> > lrwxrwxrwx 1 root root    0 Sep  8 19:03 subsystem -> ../../../class/input/
> > -rw-r--r-- 1 root root 4096 Sep  8 19:03 uevent
> > -r--r--r-- 1 root root 4096 Sep  8 19:47 uniq
>
> > # ls -l /sys/class/input/event5
> > total 0
> > -r--r--r-- 1 root root 4096 Sep  8 19:03 dev
> > lrwxrwxrwx 1 root root    0 Sep  8 19:03 device -> ../../../class/input/input5/
> > drwxr-xr-x 2 root root    0 Sep  8 19:48 power/
> > lrwxrwxrwx 1 root root    0 Sep  8 19:03 subsystem -> ../../../class/input/
> > -rw-r--r-- 1 root root 4096 Sep  8 19:03 uevent
>
> There are a few changes.
>
> There is no longer:
> /sys/class/input/eventX => /sys/class/input/inputX/eventX
> instead there is:
> /sys/class/inputX/input:eventX => /sys/class/input/eventX
> Notice the added "input:". I don't know if any software depends on this,
> though.
>
> However, the change that broke id_path of udev is that
> /sys/class/input/event5/device is now a symlink to the inputX directory
> instead of being the same as the device symlink in inputX directory,
> i.e. to ../../../devices/platform/pcspkr in this case.
>
> Udev id_path uses that directory to construct the ID_PATH variable.
> Should the sysfs structure be reverted or should udev be adapted to
> handle traversing /device symlink twice? I think the former, as there
> should be considerably more time to adapt udev for coming changes in sysfs.

Udev's path_id script is too dumb to follow the "device" link of
stacked class devices in the CONFIG_SYSFS_DEPRECATED=y layout. Does
this change fix it for you?
  http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff_plain;h=b1ac36ff5e3756cefc79967a26280056da31bf6f

Thanks,
Kay
