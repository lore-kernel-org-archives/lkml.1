Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbXFXJos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbXFXJos (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 05:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXFXJol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 05:44:41 -0400
Received: from barikada.upol.cz ([158.194.242.200]:58230 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbXFXJol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 05:44:41 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Jay L. T. Cornwall" <jay@esuna.co.uk>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: (Last oops is Tainted: P) Re: 2.6.22-rc5: pdflush oops under heavy disk load
In-Reply-To: <20070623102318.1b4f3d24.akpm@linux-foundation.org>
References: <467B12CA.5060405@esuna.co.uk> <467BE118.4090308@redhat.com> <467BE4F1.7040308@esuna.co.uk> <467D0EB0.9030100@esuna.co.uk> <20070623102318.1b4f3d24.akpm@linux-foundation.org>
Date: Sun, 24 Jun 2007 11:57:16 +0200
Message-Id: <E1I2OqK-0005VK-JF@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* From: Andrew Morton
* Newsgroups: linux.kernel
* Date: Sat, 23 Jun 2007 10:23:18 -0700
>
> On Sat, 23 Jun 2007 13:14:40 +0100 "Jay L.  T.  Cornwall" <jay@esuna.co.uk>
> wrote:
>
>> I'm beginning to suspect the Attansic L1 Gigabit Etherner driver (marked
>> as EXPERIMENTAL in 2.6.22-rc5). I can't reproduce these panics on
>> disk-to-disk copies or SCP across the localhost interface. However, SCP
>> from a server onto either of two different HDDs hits these oopses fairly
>> quickly.
>
> That sounds like a good theory: you're getting easily-hit oopses in one of
> the kernel's most-used codepaths which hasn't chanbged much in a long
> time.  So Something Odd Has Happened.

Maybe this time it's just "Tainted: P"?

|-*- <467D0EB0.9030100@esuna.co.uk> -*-
...
i2c_algo_bit dib3000mc nvidia(P) dibx000_common snd_timer tveeprom atl1
compat_ioctl32 i2c_core videodev mii psmouse snd_seq_device v4l1_compat
video_buf v4l2_common btcx_risc pcspkr shpchp snd soundcore
snd_page_alloc intel_agp pci_hotplug serio_raw tsdev evdev sr_mod cdrom
ext3 jbd mbcache sg sd_mod pata_jmicron usbhid hid ata_generic ata_piix
ahci libata scsi_mod generic ehci_hcd uhci_hcd usbcore thermal
processor fan
[  628.139866] Pid: 201, comm: kswapd0 Tainted: P
...
|-*-

And oops have no ext3, like prev. one.

[ as you know we have no automatic noise tracking system, and ]
[ developers were not so productive in last discussion of it  ]

Jay, check your oops against "Tainted: P" flag, which is not supported
here, and not drop persons, who assisted you from the CC list.
____
