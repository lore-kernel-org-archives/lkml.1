Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZKOTVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZKOTVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 14:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZKOTVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 14:21:21 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53507 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbZKOTVU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 14:21:20 -0500
MIME-Version: 1.0
In-Reply-To: <20091115170339.59528e49@lxorguk.ukuu.org.uk>
References: <40e92d5b0911150530y67878707yed776478a51a34c@mail.gmail.com>
	 <20091115170339.59528e49@lxorguk.ukuu.org.uk>
Date: Sun, 15 Nov 2009 20:21:25 +0100
Message-ID: <40e92d5b0911151121l68ef89e5s315b6c2b017bfaad@mail.gmail.com>
Subject: Re: consolechars switches tty since 8b92e87 vt: add an event 
	interface
From: =?UTF-8?Q?Przemys=C5=82aw_Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/15 Alan Cox <alan@lxorguk.ukuu.org.uk>:
>> The problem is that since 8b92e87 running consolechars switches tty to
>> the one provided with --tty option. Last commit I have tested,
>> a9366e6, is still affected.
>
> That is a suprise as the code shouldn't be changing the behaviour of any
> application unless something happened to rely on the race it fixed. Even
> then I wouldn't expect what you see.
>
> What does an strace of that command look like so I can see what ioctls it
> issues and in what order.

# strace /usr/bin/consolechars --tty=/dev/tty2 -f lat0-sun16
[ snip ]
open("/dev/tty2", O_RDWR)               = 3
ioctl(3, KDGKBTYPE, 0x7fff042a0177)     = 0
[ snip ]
ioctl(3, KDFONTOP, 0x7fff042a0150)      = 0
[ snip ]
fstat(3, {st_mode=S_IFCHR|0600, st_rdev=makedev(4, 2), ...}) = 0
ioctl(3, VT_GETSTATE, 0x7fff042a0130)   = 0
ioctl(3, VIDIOC_G_COMP or VT_ACTIVATE, 0x2) = 0
ioctl(3, VIDIOC_S_COMP or VT_WAITACTIVE, 0x2) = 0
ioctl(3, PIO_UNIMAPCLR, 0x7fff042a0160) = 0
ioctl(3, PIO_UNIMAP, 0x7fff042a0730)    = 0
ioctl(3, VIDIOC_G_COMP or VT_ACTIVATE, 0x1) = 0
ioctl(3, VIDIOC_S_COMP or VT_WAITACTIVE, 0x1) = 0
exit_group(0)

And by switching tty I mean what is meant by switching tty manually,
i.e. the result of pressing Alt+Fx under x86. Just to clarify.

I have one thing to add. It looks like that is not fully deterministic
behavior, at least not at f278a2f^ I'm using now. Occasionally tty
isn't switched. I wasn't aware of this before.

I just booted that f278a2f^ (i.e. 569ec4c) while consolechars were
limited only to console-setup script, but this time tty1 remained on
the screen and I didn't get "INIT: open(/dev/console): Input/output
error" I was seeing before. I'm not sure whether it is relevant here.

> Alan

-- 
Przemysław Pawełczyk
